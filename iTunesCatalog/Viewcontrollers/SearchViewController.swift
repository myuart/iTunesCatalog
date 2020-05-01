//
//  SearchViewController.swift
//  SearchTunes
//
//  Created by Maria Yu on 4/30/20.
//  Copyright © 2020 Maria Yu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchedData: [SearchResult] = []
    var sections = [SectionEntry<String, SearchResult>]()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        activityIndicator.style = .large
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
    }

    private func fetchSearchedData(searchText: String) {
        activityIndicator.startAnimating()
        ServiceAPI.shared.fetchSearch(for: searchText) { (result: Result<SearchResponse, ServiceAPI.APIServiceError>) in
            switch result {
              case .success(let searchResults):
                self.searchedData = searchResults.results
                self.sections = SectionEntry.group(rows: self.searchedData){$0.kind}
                self.sections.sort { lhs, rhs in lhs.sectionTitle < rhs.sectionTitle }
              case .failure(let error):
                self.searchedData = []
                self.sections = [SectionEntry<String, SearchResult>]()
                print(error.localizedDescription)
            }
            DispatchQueue.main.async() {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search iTunes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        return section.sectionTitle
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rows.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath) as! EntryTableViewCell
        
        let section = self.sections[indexPath.section]
        let entry = section.rows[indexPath.row]
        cell.nameLabel.text = entry.name
        cell.genreLabel.text = entry.primaryGenreName
        cell.linkLabel.text = entry.url
        cell.iconView.loadThumbnail(urlSting: entry.artworkUrl)
        
        /// set favorite image accordingly
        if let _ = favoriteCache.object(forKey: entry.url as AnyObject) {
            cell.favoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
        }
        else {
            cell.favoriteButton.setImage(UIImage(named: "unfavorite"), for: .normal)
        }
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text! == "" { /// if nothing entered
            DispatchQueue.main.async() {
                self.searchedData = []
                self.sections = [SectionEntry<String, SearchResult>]()
                self.tableView.reloadData()
            }
          return
        }
        fetchSearchedData(searchText: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async() {
            self.searchedData = []
            self.sections = [SectionEntry<String, SearchResult>]()
            self.tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
}

