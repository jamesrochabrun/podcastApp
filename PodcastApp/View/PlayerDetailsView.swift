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
        default: return .identity
        }
    }
}

enum MinPlayerGestureState {
    
    
    
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
    /// Stackview and miniplayer
    @IBOutlet weak var maximizedStackview: UIStackView!
    @IBOutlet weak var miniPlayerView: UIView!
    /// Mini Player UI
    @IBOutlet weak var miniplayerViewImageView: UIImageView!
    @IBOutlet weak var miniPlayerViewTitleLabel: UILabel!
    @IBOutlet weak var miniPlayerPlayPauseButton: UIButton! {
        didSet {
            miniPlayerPlayPauseButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    @IBOutlet weak var miniPlayerForward: UIButton! {
        didSet {
            miniPlayerForward.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    // MARK:- Static Function
    static func initFromNib() -> PlayerDetailsView? {
        return Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as? PlayerDetailsView
    }
    
    // MARK:- Properties
    var episode: Episode! {
        didSet {
            let viewModel = PlayerDetailsViewModel(model: episode)
            self.configure(with: viewModel)
        }
    }
    
    // MARK:- Private Properties
    private var viewModel: PlayerDetailsViewModel!
    private var animationState: AnimationState = .shrink {
        didSet {
            animateImageView(transform: animationState.imageViewTransform)
        }
    }
    private var panGesture: UIPanGestureRecognizer?
    
    private let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = true
        return player
    }()
    
    // MARK:- View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        observePlayerCurrentTime()
        observeBoundaryTime()
        setUpGestures()
    }
    
    deinit {
        print("Player memory reclaimed")
    }

    // MARK:- Config
    private func configure(with viewModel: PlayerDetailsViewModel) {
        
        self.viewModel = viewModel
        /// Max Player
        episodeTitleLabel.text = viewModel.episodeTitle
        authorLabel.text = viewModel.authorName
        if let url = viewModel.imageUrl {
            podcastImageView.sd_setImage(with: url)
        }
        if let steramUrl = viewModel.streamUrl {
            self.playEpisode(with: steramUrl)
        }
        /// Min Player
        miniPlayerViewTitleLabel.text = episodeTitleLabel.text
        miniplayerViewImageView.image = podcastImageView.image
    }
    
    fileprivate func observePlayerCurrentTime() {
        
        let interval = CMTimeMake(1, 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTimeLabel.text = time.displayString
            let durationTime = self?.player.currentItem?.duration
            self?.remainingTimeLabel.text = durationTime?.displayString
            self?.updateSlider()
        }
    }
    
    private func updateSlider() {
        
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(1, 1))
        self.currentTimeSlider.value = self.viewModel.setPercentageOnSliderValue(currentTimeSeconds, dividedBy: durationSeconds)
    }
    
    fileprivate func observeBoundaryTime() {
        
        let time = CMTimeMake(1, 3)
        let times = [NSValue(time: time)]
        /// starts an action in the closure as soon the podcast starts
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.animationState = .normal
        }
    }
    
    // MARK:- Actions
    @IBAction func dismiss(_ sender: UIButton) {
        
        guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        tabBarController.minimizePlayerDetails()
    }
    
    @IBAction func handleSliderTimeChanged(_ sender: UISlider) {
        
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let seekTime = self.viewModel.calculateSeekTimeForSliderChange(with: percentage, and: duration)
        player.seek(to: seekTime)
    }
    
    @IBAction func rewind(_ sender: UIButton) {
        self.seekToCurrentTime(delta: -15)
    }
    
    @IBAction func fastForward(_ sender: UIButton) {
        self.seekToCurrentTime(delta: 15)
    }
    
    @IBAction func handleVolumeChanged(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    private func seekToCurrentTime(delta: Int64) {
        
        let seekTime = CMTimeAdd(player.currentTime(), self.viewModel.getTimeWith(delta: delta))
        player.seek(to: seekTime)
    }
    
    @IBAction func handlePlayPause(_ sender: UIButton) {
        
        let buttonImage = self.viewModel.playPauseImage(for: player.timeControlStatus)
        playPauseButton.setImage(buttonImage, for: .normal)
        miniPlayerPlayPauseButton.setImage(buttonImage, for: .normal)
        player.timeControlStatus == .paused ? player.play() : player.pause()
        self.animationState = player.timeControlStatus == .paused ? .shrink : .normal
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
    
    // MARK:- Gestures
    func setUpGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture!)
        
        maximizedStackview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    /// Gesture actions
    @objc func handleTapMaximize() {
        UIApplication.mainTabBarController?.maximizePlayerDetails()
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            self.handleBegan(gesture: gesture)
        } else if gesture.state == .changed {
            self.handleChanged(gesture: gesture)
        } else if gesture.state == .ended {
            self.handleEnded(gesture: gesture)
        }
    }
    
    @objc func handleDismissalPan(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: superview)
        if gesture.state == .changed {
            maximizedStackview.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 07, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maximizedStackview.transform = .identity
                if translation.y > 75 {
                    UIApplication.mainTabBarController?.minimizePlayerDetails()
                }
            })
        }
    }
    
    /// Helper Methods for pan gesture states
    func handleBegan(gesture: UIPanGestureRecognizer) {
        ///
    }
    
    func handleChanged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        /// 200 is the y coordinate where the alpha will be complete changed
        self.miniPlayerView.alpha = 1 + translation.y / 200
        self.maximizedStackview.alpha = -translation.y / 200
    }
    
    func handleEnded(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 07, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            
            if translation.y < -200 || velocity.y < -500 {
                UIApplication.mainTabBarController?.maximizePlayerDetails()
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackview.alpha = 0
            }
        })
    }
}





