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
    
    func removePodcast(at index: Int) {
        
        
    }
}
