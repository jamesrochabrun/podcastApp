//
//  PlayerDetailsView.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/17/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class PlayerDetailsView: UIView {
    
    // MARK:- UI
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel! {
        didSet {
            episodeTitleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var trackSlider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    // MARK:- Properties
    var episode: Episode! {
        didSet {
            let viewModel = PlayerDetailsViewModel(model: episode)
            self.configure(with: viewModel)
        }
    }
    
    private let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    // MARK:- Config
    private func configure(with viewModel: PlayerDetailsViewModel) {
        
        episodeTitleLabel.text = viewModel.episodeTitle
        authorLabel.text = viewModel.authorName
        if let url = viewModel.imageUrl {
            podcastImageView.sd_setImage(with: url)
        }
        if let steramUrl = viewModel.streamUrl {
            self.playEpisode(with: steramUrl)
        }
    }
    
    // MARK:- Actions
    @IBAction func dismiss(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func handlePlayPause(_ sender: UIButton) {
        
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        } else {
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            player.pause()
        }
    }
    
    private func playEpisode(with url: URL) {
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
}

struct PlayerDetailsViewModel {
    
    let episodeTitle: String
    let imageUrl: URL?
    let authorName: String
    let streamUrl: URL?
    
    init(model: Episode) {
        self.episodeTitle = model.title ?? "No title provided"
        self.imageUrl = URL(string: model.imageUrl ?? "")
        self.authorName = model.author ?? "No author title"
        self.streamUrl = URL(string: model.streamUrl ?? "")
    }
}





