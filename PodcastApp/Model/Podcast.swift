//
//  Podcast.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation


struct Podcast {
    
    let name: String
    let artistName: String
}

struct PodcastViewModel {
    
    let displayName: String
    let artistDisplayName: String
    
    init(podcast: Podcast) {
        displayName = podcast.name
        artistDisplayName = podcast.artistName
    }
}
