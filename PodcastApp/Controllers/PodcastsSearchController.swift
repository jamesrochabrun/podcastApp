//
//  SearchController.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController {
    
    // MARK:- UI
    let searchController = UISearchController(searchResultsController: nil)

    // MARK:- Private properties
    private var tableDataSource: GenericTableDataSource<PodcastCell, PodcastViewModel>?
    
    // MARK:- App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        self.tableView.register(PodcastCell.self)
    }
    
    // MARK:- Set Up UI
    private func setUpSearchBar() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setUpDataSource(with models: [Podcast]) {
        tableDataSource = GenericTableDataSource(models: models.map { PodcastViewModel(podcast: $0) }) { cell, model in
            cell.configure(viewModel: model)
            return cell
        }
        self.tableView.dataSource = tableDataSource
    }
}

// MARK:- Search
extension PodcastsSearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
            self.setUpDataSource(with: podcasts)
            self.tableView.reloadData()
        }
    }
}
















