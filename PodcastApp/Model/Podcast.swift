//
//  Podcast.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation


struct Podcast: Decodable {
    
    var trackName: String?
    var artistName: String?
}

struct PodcastViewModel {
    
    let displayName: String
    let artistDisplayName: String
    
    init(podcast: Podcast) {
        displayName = podcast.trackName ?? ""
        artistDisplayName = podcast.artistName ?? ""
    }
}
