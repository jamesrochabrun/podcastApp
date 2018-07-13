//
//  EpisodesController.swift
//  PodcastApp
//
//  Created by James Rochabrun on 6/26/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    // MARK:- Public properties
    var podcast: Podcast? {
        didSet {
            guard let p = podcast else { return }
            self.updateUI(with: EpisodeControllerViewModel(model: p))
        }
    }
    
    // MARK:- Private properties
    private var tableDataSource: GenericTableDataSource<EpisodeCell, Episode>?
    
    // MARK:- App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    // MARK:- Set Up UI
    private func updateUI(with model: EpisodeControllerViewModel) {
        setUpNav(title: model.title)
        guard let feedUrl = model.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { episodes in
            self.setUpDataSource(with: episodes)
        }
    }
    
    private func setUpTableView() {
        self.tableView.registerNib(EpisodeCell.self)
        self.tableView.tableFooterView = UIView() // remove horizontal lines for empty table view.
    }
    
    private func setUpDataSource(with models: [Episode]) {
        
        tableDataSource = GenericTableDataSource(models: models) { cell, model in
            let vModel = EpisodeViewModel(model: model)
            cell.configure(viewModel: vModel)
            return cell
        }
        self.tableView.dataSource = tableDataSource
        self.tableView.reloadData()
    }
    
    private func setUpNav(title: String) {
        self.title = title
    }
}

// MARK:- UITableViewDelegate
extension EpisodesController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

