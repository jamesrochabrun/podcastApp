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
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}

struct PodcastViewModel {
    
    let displayName: String
    let artistDisplayName: String
    let episodeCount: String
    let thumbnailArtworkUrl: String
    
    init(podcast: Podcast) {
        displayName = podcast.trackName ?? ""
        artistDisplayName = podcast.artistName ?? ""
        episodeCount = "\(podcast.trackCount ?? 0) Episodes"
        thumbnailArtworkUrl = podcast.artworkUrl600 ?? ""
    }
}
