//
//  SearchDataModel.swift
//  SearchTunes
//
//  Created by Maria Yu on 4/30/20.
//  Copyright © 2020 Maria Yu. All rights reserved.
//

import Foundation

/// I have wanted to use Codable, but the media type "audiobook" has a different json format from others, so cannot use Codable.

struct SearchResponse {
    let resultCount: Int
    let results: [SearchResult]
}

struct SearchResult {
    let kind: String
    let id: Int64
    let artistName: String
    let name: String
    let url: String
    let artworkUrl: String
    let primaryGenreName: String
    
    init(kind: String, id: Int64, artistName: String, name: String, url: String, artworkUrl: String, primaryGenreName: String) {
        self.kind = kind
        self.id = id
        self.artistName = artistName
        self.name = name
        self.url = url
        self.artworkUrl = artworkUrl
        self.primaryGenreName = primaryGenreName
    }
}
