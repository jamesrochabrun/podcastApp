//
//  CMTime+Extension.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/19/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    
    var displayString: String {
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
}
