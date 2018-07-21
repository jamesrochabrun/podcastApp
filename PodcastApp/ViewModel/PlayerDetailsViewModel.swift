//
//  PlayerDetailsViewModel.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/19/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import AVKit

struct PlayerDetailsViewModel {
    
    let episodeTitle: String
    let imageUrl: URL?
    let authorName: String
    let streamUrl: URL?
    /// 200 is the y coordinate where the alpha will be complete changed
    static let positionY: CGFloat = 200.0
    static let velocity: CGFloat = 500.0
    
    init(model: Episode) {
        self.episodeTitle = model.title ?? "No title provided"
        self.imageUrl = URL(string: model.imageUrl ?? "")
        self.authorName = model.author ?? "No author title"
        self.streamUrl = URL(string: model.streamUrl ?? "")
    }
    
    /// Buttons
    func playPauseImage(for status: AVPlayerTimeControlStatus) -> UIImage {
        return status == .playing ? #imageLiteral(resourceName: "play") : #imageLiteral(resourceName: "pause")
    }
    
    /// Time seek
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
    
    /// Animation Translations limits
    
    /// Pan Gesture
    func dismisalPanLimitReached(from translationY: CGFloat) -> Bool {
        return translationY > 75
    }
    
    /// Gesture change
    func getAlphasForViewsWhenGestureChange(from translationY: CGFloat) -> (mimizedAlpha: CGFloat, maximizedAlpha: CGFloat) {
        let mimizedAlpha = 1 + translationY / PlayerDetailsViewModel.positionY
        let maximizedAlpha = -translationY / PlayerDetailsViewModel.positionY
        return (mimizedAlpha: mimizedAlpha, maximizedAlpha: maximizedAlpha)
    }
    
    /// Gesture Ended
    func didLimitReached(with translationY: CGFloat, or velocityY: CGFloat) -> Bool {
        return translationY < -200 || velocityY < -500
    }

}









