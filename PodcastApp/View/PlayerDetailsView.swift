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
import MediaPlayer

/// Object that manages the animation state for the imageview
enum ImageViewAnimationstate {
    
    case normal
    case shrink
    
    var imageViewTransform: CGAffineTransform {
        switch self {
        case .normal: return CGAffineTransform.identity
        case .shrink: return CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
}

protocol PlayerDetailsViewDelegate: class {
    func maximizePlayerDetails(with episode: Episode?)
    func minimizePlayerDetails()
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
        return Bundle.loadNib(PlayerDetailsView.self, owner: self)
    }
    
    // MARK:- Properties
    var episode: Episode! {
        didSet {
            let viewModel = PlayerDetailsViewModel(model: episode)
            self.configure(with: viewModel)
        }
    }
    var delegate: PlayerDetailsViewDelegate?
    
    // MARK:- Private Properties
    private var viewModel: PlayerDetailsViewModel!
    private var animationState: ImageViewAnimationstate = .shrink {
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
        setUpAudioSession()
        setUpRemoteControl()
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
        
        /// Lock screen
        setUplNowPlayingInfo(with: viewModel)

        /// Max Player
        episodeTitleLabel.text = viewModel.episodeTitle
        authorLabel.text = viewModel.authorName
        if let url = viewModel.imageUrl {
            podcastImageView.sd_setImage(with: url) { image, _, _, _ in
                
                guard let image = image else { return }
                /// lockscreen artwork getting the dict
                var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
                
                let arwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> UIImage in
                    return image
                })
                
                nowPlayingInfo?[MPMediaItemPropertyArtwork] = arwork
                /// writing on the dict
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
        }
        if let steramUrl = viewModel.streamUrl {
            self.playEpisode(with: steramUrl)
        }
        /// Min Player
        miniPlayerViewTitleLabel.text = episodeTitleLabel.text
        miniplayerViewImageView.image = podcastImageView.image
        
    }
    
    private func setUplNowPlayingInfo(with viewModel: PlayerDetailsViewModel) {
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = viewModel.episodeTitle
        nowPlayingInfo[MPMediaItemPropertyArtist] = viewModel.authorName
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func setUpAudioSession() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let err {
            print("Failed to activate session with error \(err)")
        }
    }
    
    private func setUpRemoteControl() {
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { _ in
            self.playPause()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { _ in
            self.playPause()
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { _ in
            self.playPause()
            return .success
        }
    }
    
    fileprivate func observePlayerCurrentTime() {
        
        let interval = CMTimeMake(1, 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTimeLabel.text = time.displayString
            let durationTime = self?.player.currentItem?.duration
            self?.remainingTimeLabel.text = durationTime?.displayString
            self?.setUplLockScreenCurrentTime()
            self?.updateSlider()
        }
    }
    
    private func setUplLockScreenCurrentTime() {
        
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        guard let currentItem = player.currentItem else { return }
        /// track time correctly
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        
        let durationInSeconds = currentItem.duration
        nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(durationInSeconds)

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
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
        delegate?.minimizePlayerDetails()
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
        playPause()
    }
    
    private func playPause() {
        
        updatePlayPauseButton()
        player.timeControlStatus == .paused ? player.play() : player.pause()
        self.animationState = player.timeControlStatus == .paused ? .shrink : .normal
    }
    
    private func updatePlayPauseButton() {
        
        let buttonImage = self.viewModel.playPauseImage(for: player.timeControlStatus)
        playPauseButton.setImage(buttonImage, for: .normal)
        miniPlayerPlayPauseButton.setImage(buttonImage, for: .normal)
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
        delegate?.maximizePlayerDetails(with: nil)
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
                if self.viewModel.dismisalPanLimitReached(from: translation.y) {
                    self.delegate?.minimizePlayerDetails()
                }
            })
        }
    }
    
    /// Helper Methods for pan gesture states
    func handleBegan(gesture: UIPanGestureRecognizer) {
        /// Do nothing for now
    }
    
    func handleChanged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        let alphas = self.viewModel.getAlphasForViewsWhenGestureChange(from: translation.y)
        self.miniPlayerView.alpha = alphas.mimizedAlpha
        self.maximizedStackview.alpha = alphas.maximizedAlpha
    }
    
    func handleEnded(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 07, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if self.viewModel.didLimitReached(with: translation.y, or: velocity.y) {
                self.delegate?.maximizePlayerDetails(with: nil)
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackview.alpha = 0
            }
        })
    }
}

protocol Guarded {}

extension Optional: Guarded {
    
    func guarded<T: ExpressibleByNilLiteral>(_ value: T?, completion: () -> ()?) {
        guard let _ = value else { completion(); return }
    }
    
}


