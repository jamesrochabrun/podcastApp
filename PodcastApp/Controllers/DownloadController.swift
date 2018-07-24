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
        
        let episode = self.tableDataSource?.object(at: indexPath)
        if let _ = episode?.fileUrl {
            /// Launch episode player
            UIApplication.mainTabBarController?.maximizePlayerDetails(with: episode)
        } else {
            /// let say that the download wasnt complete for any reason so the file url does not exist, lets alert the user
            let alertController = UIAlertController(title: "File url not found", message: "Can not find local file, playing from streaming?", preferredStyle: .actionSheet)
            let alertAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                UIApplication.mainTabBarController?.maximizePlayerDetails(with: episode)
            }
            let cancelAction = UIAlertAction(title: "No", style: .cancel) { (_) in }
            alertController.addAction(alertAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
    }
}






















