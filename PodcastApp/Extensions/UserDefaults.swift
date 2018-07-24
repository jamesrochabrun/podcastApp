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
    static let downloadedEpisodeKey = "dowloadedEpisode"
    
    func download(episode: Episode) {
        
        do {
            var downloadedEpisodes = self.downloadedEpisodes()
            downloadedEpisodes.append(episode)
            let data = try JSONEncoder().encode(downloadedEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
        } catch let err {
            print("Error on encoding episode wit error = \(err)")
        }
    }
    
    func downloadedEpisodes() -> [Episode] {
        
        guard let episodesData = data(forKey: UserDefaults.downloadedEpisodeKey) else { return [] }
        /// decode
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodes
        } catch let err {
            print("Error on decoding episodes wit error = \(err)")
        }
        return []
        
    }
    
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
