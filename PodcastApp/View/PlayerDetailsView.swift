//
//  PlayerDetailsView.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/17/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class PlayerDetailsView: UIView {
    
    var episode: Episode! {
        didSet {
            let viewModel = PlayerDetailsViewModel(model: episode)
            self.configure(with: viewModel)
        }
    }
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel! {
        didSet {
            episodeTitleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var trackSlider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    
    
    // MARK:- Actions
    @IBAction func dismiss(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    // MARK:- Config
    private func configure(with viewModel: PlayerDetailsViewModel) {
        episodeTitleLabel.text = viewModel.episodeTitle
        authorLabel.text = viewModel.authorName
        if let url = viewModel.imageUrl {
            podcastImageView.sd_setImage(with: url)
        }
    }
}

struct PlayerDetailsViewModel {
    
    let episodeTitle: String
    let imageUrl: URL?
    let authorName: String
    
    init(model: Episode) {
        self.episodeTitle = model.title ?? "No title provided"
        self.imageUrl = URL(string: model.imageUrl ?? "")
        self.authorName = model.author ?? "No author title"
    }
}





