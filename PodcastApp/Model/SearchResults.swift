//
//  SearchResults.swift
//  PodcastApp
//
//  Created by James Rochabrun on 6/1/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

struct SearchResults: Decodable {
    
    let resultCount: Int
    let results: [Podcast]
}
