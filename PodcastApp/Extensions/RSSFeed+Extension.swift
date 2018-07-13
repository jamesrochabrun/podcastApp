//
//  RSSFeed+Extension.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/13/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import FeedKit

extension RSSFeed {
    
    func toEpisodes() -> [Episode] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        if let episodes: [Episode] = items?.compactMap ({
            var episode = Episode(item: $0)
            if episode.imageUrl == nil {
                /// if feed does not have a podcast episode image available, set the podcast cover as image
                episode.imageUrl = imageUrl
            }
            return episode
        }) {
            return episodes
        }
        return []
    }
}
