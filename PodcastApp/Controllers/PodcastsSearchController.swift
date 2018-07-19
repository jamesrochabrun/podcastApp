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
    private var tableDataSource: GenericTableDataSource<PodcastCell, Podcast>?
    
    // MARK:- App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpTableView()
        searchBar(searchController.searchBar, textDidChange: "Voong")
    }
    
    // MARK:- Set Up UI
    private func setUpTableView() {
        self.tableView.registerNib(PodcastCell.self)
        self.tableView.tableFooterView = UIView() // remove horizontal lines for empty table view.
    }
    
    private func setUpSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true // display navbar in pushed view controller
    }
    
    private func setUpDataSource(with models: [Podcast]) {
        tableDataSource = GenericTableDataSource(models: models) { cell, model in
            let vModel = PodcastViewModel(podcast: model)
            cell.configure(viewModel: vModel)
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a search term"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let dataSource = self.tableDataSource else { return 0 }
        return dataSource.count > 0 ? 0 : 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let episodesControler = EpisodesController()
        guard let dataSource = self.tableDataSource else { return }
        episodesControler.podcast = dataSource.object(at: indexPath)
        navigationController?.pushViewController(episodesControler, animated: true)
    }
}
















