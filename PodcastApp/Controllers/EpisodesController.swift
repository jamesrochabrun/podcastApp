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
    
    // MARK:- UI
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = .darkGray
        return activityIndicator
    }()
    
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
        setUpNavigationBarButtons()
    }
    
    // MARK:- Set Up UI
    private func updateUI(with model: EpisodeControllerViewModel) {
        setUpNav(title: model.title)
        guard let feedUrl = model.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { episodes in
            self.setUpDataSource(with: episodes)
        }
    }
    
    private func setUpNavigationBarButtons() {
        
        /// check if the podcast is already marked as favorite
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        
        /// if index is not nil that means that podcast already exists.
        if let _ = savedPodcasts.index(where: {
            $0.trackName == self.podcast?.trackName &&
                $0.artistName == self.podcast?.artistName }) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "like"), style: .plain, target: nil, action: nil)
        } else {
            let favButton = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite))
            navigationItem.rightBarButtonItems = [favButton]
        }
    }
    
    private func setUpTableView() {
        self.tableView.registerNib(EpisodeCell.self)
        self.tableView.tableFooterView = UIView() // remove horizontal lines for empty table view.
    }
    
    private func setUpDataSource(with models: [Episode]) {
        
        tableDataSource = GenericTableDataSource(models: models) { cell, model in
            let vModel = EpisodeCellViewModel(model: model)
            cell.configure(viewModel: vModel)
            return cell
        }
        self.tableView.dataSource = tableDataSource
        self.tableView.reloadData()
    }
    
    private func setUpNav(title: String) {
        self.title = title
    }
    
    // MARK:- Actions
    @objc func handleSaveFavorite() {
        
        /// 1. get the podcast that will be favorited
        guard let podcast = self.podcast else { return }
        /// 2. get all the saved podcasts
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        /// 3. Append it to the podcasts array
        var listOfSavedPodcasts = savedPodcasts
        listOfSavedPodcasts.append(podcast)
        /// 4. Tansform the podcasts array in to data
        let podcastsData = NSKeyedArchiver.archivedData(withRootObject: listOfSavedPodcasts)
        /// 5. Save the data in user defaults
        UserDefaults.standard.set(podcastsData, forKey: UserDefaults.favoritePodcastKey)
        /// 6. Update UI if needed
        showBadgeHighLight()
    }
    
    private func showBadgeHighLight() {
        UIApplication.mainTabBarController?.favoriteNav?.tabBarItem.badgeValue = "New"
        /// Update heart
           navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "like"), style: .plain, target: nil, action: nil)
    }
}


// MARK:- UITableViewDelegate
extension EpisodesController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 132.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let episode = self.tableDataSource?.object(at: indexPath) else { return }
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let tabBarController = window.rootViewController as? MainTabBarController else { return }
        tabBarController.maximizePlayerDetails(with: episode)
       // guard let playerDetailView = PlayerDetailsView.initFromNib() else { return }
        //playerDetailView.episode = episode
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        activityIndicator.startAnimating()
        return self.activityIndicator
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let dSource = self.tableDataSource else { return 200 }
        dSource.isEmpty ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        return dSource.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let episode = self.tableDataSource?.object(at: indexPath) else { return [] }
        let downloadAction = UITableViewRowAction(style: .normal, title: "Downloading") { (_, _) in
            UserDefaults.standard.download(episode: episode)
            /// Download a podcast episode using Alamofire
            APIService.shared.download(episode: episode)
        }
        return [downloadAction]
    }
}










