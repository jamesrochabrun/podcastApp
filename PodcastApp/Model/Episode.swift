//
//  Episode.swift
//  PodcastApp
//
//  Created by James Rochabrun on 6/26/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import FeedKit

struct Episode: Codable { // better than NScoding
    
    var title: String?
    var description: String?
    var date: Date?
    var imageUrl: String?
    let author: String?
    let streamUrl: String?
    var fileUrl: String?

}

extension Episode {
    
    init(item: RSSFeedItem) {
        self.title = item.title
        self.description = item.iTunes?.iTunesSubtitle ?? item.description
        self.date = item.pubDate
        self.imageUrl = item.iTunes?.iTunesImage?.attributes?.href
        self.author = item.iTunes?.iTunesAuthor
        /// getting the episode url data
        self.streamUrl = item.enclosure?.attributes?.url
    }
}





