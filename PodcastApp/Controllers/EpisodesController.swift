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
        let parser = FeedParser(URL: feedUrl)
        parser.parseAsync { (result) in
            switch result {
            case let .rss(feed):
                if let episodes = feed.items?.compactMap({ Episode(item: $0) }) {
                    DispatchQueue.main.async {
                        self.setUpDataSource(with: episodes)
                    }
                }
            case let .failure(error):
                print("the error is!!!, \(error)")
            default: break
            }
        }
    }
    
    private func setUpTableView() {
        self.tableView.registerNib(PodcastCell.self)
        self.tableView.tableFooterView = UIView() // remove horizontal lines for empty table view.
    }
    
    private func setUpDataSource(with models: [Episode]) {
        
        tableDataSource = GenericTableDataSource(models: models) { cell, model in
            let vModel = EpisodeViewModel(model: model)
            //cell.configure(viewModel: vModel)
//            cell.trackNameLabel.text = vModel.title
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
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.text = "Please enter a search term"
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 22)
//        label.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
//        return label
//    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        guard let dataSource = self.tableDataSource else { return 0 }
//        return dataSource.count > 0 ? 0 : 132
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

