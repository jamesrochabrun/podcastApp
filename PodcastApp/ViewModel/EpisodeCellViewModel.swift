//
//  EpisodeCellViewModel.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/19/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

struct EpisodeCellViewModel {
    
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
