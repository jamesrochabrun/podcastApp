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
    
    func setUpGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
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
    
    @objc func handleTapMaximize() {
        guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        tabBarController.maximizePlayerDetails(with: nil)
    }
    
    /// Min Player actions
    
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
    
    func getTimeWith(delta: Int64) -> CMTime {
        return CMTimeMake(delta, 1)
    }
    
    func setPercentageOnSliderValue(_ currentTimeSeconds: Float64, dividedBy durationSeconds: Float64) -> Float {
        let percentage = currentTimeSeconds / durationSeconds
        return Float(percentage)
    }
    
    func calculateSeekTimeForSliderChange(with percentage: Float, and duration: CMTime) -> CMTime {
        
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, 1)
        return seekTime
    }
}





