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
        setUpTableView()
    }
    
    // MARK:- Set Up UI
    private func setUpTableView() {
        self.tableView.registerNib(PodcastCell.self)
    }
    
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

// MARK:- UITableViewDelegate
extension PodcastsSearchController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132.0
    }
}
















