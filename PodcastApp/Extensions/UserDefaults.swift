//
//  UserDefaults.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/23/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoritePodcastKey = "favoritePodcastKey"
    
    func savedPodcasts() -> [Podcast] {
        guard let data = UserDefaults.standard.value(forKey: UserDefaults.favoritePodcastKey) as? Data else { return  [] }
        guard let listOfSavedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Podcast] else { return [] }
        return listOfSavedPodcasts
    }
    
    func removePodcast(_ podcast: Podcast) {
        
        let podcasts = savedPodcasts()
        let filteredPodcasts = podcasts.filter {
            return $0.trackName != podcast.trackName && $0.artistName != podcast.artistName
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
    }
}
