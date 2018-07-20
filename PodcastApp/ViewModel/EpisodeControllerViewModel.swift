//
//  EpisodeControllerViewModel.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/19/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

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
