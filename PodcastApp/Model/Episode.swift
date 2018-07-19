//
//  Episode.swift
//  PodcastApp
//
//  Created by James Rochabrun on 6/26/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import FeedKit

struct Episode {
    
    var title: String?
    var description: String?
    var date: Date?
    var imageUrl: String?
    let author: String?
    
    init(item: RSSFeedItem) {
        self.title = item.title
        self.description = item.iTunes?.iTunesSubtitle ?? item.description
        self.date = item.pubDate
        self.imageUrl = item.iTunes?.iTunesImage?.attributes?.href
        self.author = item.iTunes?.iTunesAuthor
    }
}

struct EpisodeViewModel {
    
    let title: String
    let description: String
    let date: String
    var episodeThumbnailUrl: URL?
    var authorName: String
    
    init(model: Episode) {
        self.title = model.title ?? "No title provided"
        self.description = model.description ?? "No description available"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        self.date = dateFormatter.string(from: model.date ?? Date())
        if let imageUrl = model.imageUrl {
            self.episodeThumbnailUrl = URL(string: imageUrl)
        }
        self.authorName = model.author ?? "No author title provided"
    }
}

/// Dependency injection from the searchcontroller
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
