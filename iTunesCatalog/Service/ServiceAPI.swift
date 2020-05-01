//
//  ServiceAPI.swift
//  TesURLSession
//
//  Created by Maria Yu on 4/29/20.
//  Copyright © 2020 Maria Yu. All rights reserved.
//

import Foundation

class ServiceAPI {
    public static let shared = ServiceAPI()
    private init() {}
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://itunes.apple.com/search?")!
    private let jsonDecoder = JSONDecoder()
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case parseError
        case downloadImageError
    }
    
    typealias JSONDictionary = [String: Any]
    
    public func fetchSearch(for searchTerm: String, result: @escaping (Result<SearchResponse, APIServiceError>) -> Void) {
        let searchURL = baseURL
        guard var urlComponents = URLComponents(url: searchURL, resolvingAgainstBaseURL: true) else {
            return
        }
        
        let queryItems = [URLQueryItem(name: "term", value: searchTerm)]
        urlComponents.queryItems = queryItems
        
        fetchResources(urlComponents: urlComponents, completion: result)
    }

    private func fetchResources(urlComponents: URLComponents, completion: @escaping (Result<SearchResponse, APIServiceError>) -> Void) {
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
     
        urlSession.dataTask(with: url) { (result) in
            switch result {
                case .failure:
                    completion(.failure(.apiError))
            
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200
                    else {
                            completion(.failure(.invalidResponse))
                        return
                    }
                    
                    if let results = self.updateSearchResults(data) {
                        completion(.success(results))
                    } else {
                        completion(.failure(.parseError))
                    }
            }
         }.resume()
    }
    
    private func updateSearchResults(_ data: Data) -> SearchResponse?  {
        var jsonDictionary: JSONDictionary?
        
        do {
            jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            let errorMessage = "JSONSerialization error: \(parseError.localizedDescription)\n"
            print(errorMessage)
            return nil
        }
        
        guard let resultCount = jsonDictionary!["resultCount"] as? Int else {
            let errorMessage = "Dictionary does not contain resultCount key.\n"
            print(errorMessage)
            return nil
        }
            
        guard let results = jsonDictionary!["results"] as? [Any] else {
            let errorMessage = "Dictionary does not contain results.\n"
            print(errorMessage)
            return nil
        }
        
        var entries: [SearchResult] = []
        for entry in results {
            if let entry = entry as? JSONDictionary,
            let wrapperType = entry["wrapperType"] as? String,
            let artistName = entry["artistName"] as? String,
            let artworkUrl = entry["artworkUrl60"] as? String,
            let primaryGenreName = entry["primaryGenreName"] as? String {
            var kind = ""
            var trackId: Int64 = 0
            var name = ""
            var url = ""
            /// need to do this because "audiobook" has a different json format.
            if wrapperType == "audiobook" {
                kind = "audiobook"
                if let id = entry["artistId"] as? Int64 {
                    trackId = id
                }
                if let collectionName = entry["collectionName"] as? String {
                    name = collectionName
                }
                if let trackViewUrl = entry["artistViewUrl"] as? String {
                    url = trackViewUrl
                }
            }
            else {
                if let entry_kind = entry["kind"] as? String {
                    kind = entry_kind
                }
                if let id = entry["trackId"] as? Int64 {
                    trackId = id
                }
                if let trackName = entry["trackName"] as? String {
                    name = trackName
                }
                if let trackViewUrl = entry["trackViewUrl"] as? String {
                    url = trackViewUrl
                }
            }
                
            entries.append(SearchResult(kind: kind, id: trackId, artistName: artistName, name: name, url: url, artworkUrl: artworkUrl, primaryGenreName: primaryGenreName))
             } else {
               let errorMessage = "Problem occurred during parsing search results.\n"
                print(errorMessage)
                return nil
             }
        }
        
        let searchResponse = SearchResponse(resultCount: resultCount, results: entries)
        
        return searchResponse
    }
    
    public func downloadImage(url: URL, completion: @escaping (Result<Data, APIServiceError>) -> Void) {
        urlSession.dataTask(with: url) { (result) in
           switch result {
               case .failure:
                   completion(.failure(.downloadImageError))
           
               case .success(let (response, data)):
                   guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200
                       else {
                           completion(.failure(.invalidResponse))
                       return
                   }
                   
                   DispatchQueue.main.async() {
                       completion(.success(data))
                   }
           }
        }.resume()
    }
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}

