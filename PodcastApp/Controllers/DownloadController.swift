//
//  DownloadController.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class DownloadController: UITableViewController {
    
    // MARK:- Private properties
    private var tableDataSource: GenericTableDataSource<EpisodeCell, Episode>?
    
    // MARK:- App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpDataSource()
    }
    
    // MARK:- Set Up UI
    private func setUpTableView() {
        tableView.registerNib(EpisodeCell.self)
    }
    
    private func setUpDataSource() {
        
        let episodes = UserDefaults.standard.downloadedEpisodes()
        tableDataSource = GenericTableDataSource(models: episodes) { cell, model in
            let vModel = EpisodeCellViewModel(model: model)
            cell.configure(viewModel: vModel)
            return cell
        }
        self.tableView.dataSource = tableDataSource
        self.tableView.reloadData()
    }
}

// MARK:- UItableviewDelegate
extension DownloadController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Launch episode player
        let episode = self.tableDataSource?.object(at: indexPath)
        UIApplication.mainTabBarController?.maximizePlayerDetails(with: episode)
    }
}








