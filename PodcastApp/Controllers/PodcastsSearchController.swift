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
    private let searchController = UISearchController(searchResultsController: nil)
    private var podcastsSearchView = Bundle.main.loadNibNamed("PodcastSearchingView", owner: self, options: nil)?.first as? UIView

    // MARK:- Private properties
    private var tableDataSource: GenericTableDataSource<PodcastCell, Podcast>?
    private var timer: Timer?
    
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
        
        /// introducing a delay to avoid agressive calls to the API
        self.tableDataSource = nil
        self.tableView.reloadData()
 
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [unowned self] _ in
            APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
                self.setUpDataSource(with: podcasts)
                self.tableView.reloadData()
            }
        })
    }
}

// MARK:- UITableViewDelegate
extension PodcastsSearchController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return Bundle.main.loadNibNamed("SearchHeaderView", owner: self, options: nil)?.first as? UIView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let dataSource = self.tableDataSource else { return 0 }
        return dataSource.isEmpty  && searchController.searchBar.text?.isEmpty == true ? 250 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let episodesControler = EpisodesController()
        guard let dataSource = self.tableDataSource else { return }
        episodesControler.podcast = dataSource.object(at: indexPath)
        navigationController?.pushViewController(episodesControler, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.podcastsSearchView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let dSource = self.tableDataSource else { return 200 }
        return dSource.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
    }
}
















