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


/// Object that manages the animation state
enum AnimationState {
    
    case normal
    case shrinked
    
    var imageViewTransform: CGAffineTransform {
        
        switch self {
        case .normal: return CGAffineTransform.identity
        case .shrinked: return CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
}

class PlayerDetailsView: UIView {
    
    // MARK:- UI
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var podcastImageView: UIImageView! {
        didSet {
            podcastImageView.layer.cornerRadius = 5
            podcastImageView.clipsToBounds = true
            podcastImageView.transform = self.animationState.imageViewTransform
        }
    }
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
    
    private var animationState: AnimationState = .shrinked {
        didSet {
            animateImageView(transform: animationState.imageViewTransform)
        }
    }
    
    private let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    // MARK:- View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let time = CMTimeMake(1, 3)
        let times = [NSValue(time: time)]
        /// starts an action in the closure as soon the podcast starts
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            self.animationState = .normal
        }
    }

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
            self.animationState = .normal
        } else {
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            player.pause()
            self.animationState = .shrinked
        }
    }
    
    private func playEpisode(with url: URL) {
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    private func animateImageView(transform: CGAffineTransform) {
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.podcastImageView.transform = transform
        })
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





