//
//  Podcast.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

/// Encoding:

/// 1 Make the object a class, it should be a subclass of NSObject, and conform to NSCoding
/// 2 set the loginc to encode properties
/// 3 use the NSKeyedArchiver.archivedData to save the custom object in user defaults

/// Decoding

/// 1 check the coder method here...

struct DecoEncodeKeys {
    
    static let trackName = "trackNameKey"
    static let artistName = "artistNameKey"
    static let artworkUrl = "artworkUrl600Key"

}

class Podcast: NSObject, Decodable, NSCoding {
    
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
    func encode(with aCoder: NSCoder) {
        print("trying to transform Podcast in to data")
        aCoder.encode(trackName ?? "track Name", forKey: DecoEncodeKeys.trackName)
        aCoder.encode(artistName ?? "Artwork Name", forKey: DecoEncodeKeys.artistName)
        aCoder.encode(artworkUrl600 ?? "Artwork no provided", forKey: DecoEncodeKeys.artworkUrl)

    }
    
    required init?(coder aDecoder: NSCoder) {
        print("trying to transform data in to Podcast")
        self.trackName = aDecoder.decodeObject(forKey: DecoEncodeKeys.trackName) as? String
        self.artistName = aDecoder.decodeObject(forKey: DecoEncodeKeys.artistName) as? String
        self.artworkUrl600 = aDecoder.decodeObject(forKey: DecoEncodeKeys.artworkUrl) as? String

    }
}

struct PodcastViewModel {
    
    let displayName: String
    let artistDisplayName: String
    let episodeCount: String
    let thumbnailArtworkUrl: String
    
    init(podcast: Podcast) {
        displayName = podcast.trackName ?? ""
        artistDisplayName = podcast.artistName ?? ""
        episodeCount = "\(podcast.trackCount ?? 0) Episodes"
        thumbnailArtworkUrl = podcast.artworkUrl600 ?? ""
    }
}
