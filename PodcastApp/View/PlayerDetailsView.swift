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
    case shrink
    
    var imageViewTransform: CGAffineTransform {
        
        switch self {
        case .normal: return CGAffineTransform.identity
        case .shrink: return CGAffineTransform(scaleX: 0.7, y: 0.7)
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
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    // MARK:- Properties
    var episode: Episode! {
        didSet {
            let viewModel = PlayerDetailsViewModel(model: episode)
            self.configure(with: viewModel)
        }
    }
    
    private var viewModel: PlayerDetailsViewModel!
    
    private var animationState: AnimationState = .shrink {
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
        
        observePlayerCurrentTime()
        observeBoundaryTime()
    }

    // MARK:- Config
    private func configure(with viewModel: PlayerDetailsViewModel) {
        
        self.viewModel = viewModel
        episodeTitleLabel.text = viewModel.episodeTitle
        authorLabel.text = viewModel.authorName
        if let url = viewModel.imageUrl {
            podcastImageView.sd_setImage(with: url)
        }
        if let steramUrl = viewModel.streamUrl {
            self.playEpisode(with: steramUrl)
        }
    }
    
    fileprivate func observePlayerCurrentTime() {
        
        let interval = CMTimeMake(1, 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            self.currentTimeLabel.text = time.displayString
            let durationTime = self.player.currentItem?.duration
            self.remainingTimeLabel.text = durationTime?.displayString
            self.updateSlider()
        }
    }
    
    private func updateSlider() {
        
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(1, 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    fileprivate func observeBoundaryTime() {
        
        let time = CMTimeMake(1, 3)
        let times = [NSValue(time: time)]
        /// starts an action in the closure as soon the podcast starts
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            self.animationState = .normal
        }
    }
    
    // MARK:- Actions
    @IBAction func dismiss(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func handlePlayPause(_ sender: UIButton) {
        
        let buttonImage = self.viewModel.playPauseImage(for: player.timeControlStatus)
        playPauseButton.setImage(buttonImage, for: .normal)
        player.timeControlStatus == .paused ? player.play() : player.pause()
        self.animationState = player.timeControlStatus == .playing ? .normal : .shrink
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
    
    func playPauseImage(for status: AVPlayerTimeControlStatus) -> UIImage {
        return status == .playing ? #imageLiteral(resourceName: "play") : #imageLiteral(resourceName: "pause")
    }
}





