//
//  Episode.swift
//  PodcastApp
//
//  Created by James Rochabrun on 6/26/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

struct Episode {
    var title: String?
}

struct EpisodeViewModel {
    
    let title: String
    
    init(model: Episode) {
        self.title = model.title ?? "No title provided"
    }
}

struct EpisodeControllerViewModel {
    
    let title: String
    var feedUrl: URL?
    
    init(model: Podcast) {
        self.title = model.artistName ?? "No name provided"
        
        /// trick for secure the URL if possible
        guard let feedUrl = model.feedUrl else { return }
        let secureFeedUrl = feedUrl.contains("https") ? model.feedUrl : model.feedUrl?.replacingOccurrences(of: "http", with: "https")
        guard let secureUrlStr = secureFeedUrl else { return }
        self.feedUrl = URL(string: secureUrlStr)
    }
}
