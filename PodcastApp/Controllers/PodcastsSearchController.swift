//
//  SearchController.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class PodcastsSearchController: UITableViewController {
    
    let podcasts = [
        
        Podcast(name: "1", artistName: "a"),
        Podcast(name: "2", artistName: "b"),
        Podcast(name: "3", artistName: "c"),
        Podcast(name: "4", artistName: "d"),
        Podcast(name: "5", artistName: "e"),
        Podcast(name: "6", artistName: "f")
    ]
    
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
    private func setUpSearchBar() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setUpTableView() {
        self.tableView.register(PodcastCell.self)
        tableDataSource = GenericTableDataSource(models: podcasts.map { PodcastViewModel(podcast: $0) }) { cell, model in
            cell.configure(viewModel: model)
            return cell
        }
        self.tableView.dataSource = tableDataSource
    }
}

extension PodcastsSearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(searchText)")
    }
}









