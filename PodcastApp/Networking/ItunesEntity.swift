//
//  ItunesEntity.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

//MARK: defining a protocol for the top entity level
protocol ItunesEntity: QueryItemProvider {
    
    var entityName: String { get }
}

//MARK: extending ItunesEntity to set the computed property of QueryitemProvider
//here we are not making that the music entity confroms directly to queryitemprovider instead we are conforming the protocol to do that work
extension ItunesEntity {
    
    var queryItem: URLQueryItem {
        return URLQueryItem(name: "entity", value: entityName)//"entity" is provode by api documentation
    }
}

//MARK: Music case has nested cases, creating an enum for the music case
//music is just one case of medias on itunes
enum MusicEntity: String {
    
    case musicArtist
    case musicTrack
    case album
    case musicVideo
    case mix
    case song
}

//MARK: making Mus
extension MusicEntity: ItunesEntity {
    
    var entityName: String {
        return self.rawValue //returns for example "album"
    }
}

//here we are not making that the music entity confroms directly to queryitemprovider instead we are conforming the protocol to do that work
//extension MusicEntity: QueryItemProvider {
//
//    var queryItem: URLQueryItem {
//      return URLQueryItem(name: "", value: "")
//    }
//
//}
//MARK: - rest of entities
enum MovieEntity: String, ItunesEntity {
    case movieArtist
    case movie
    
    var entityName: String {
        return self.rawValue
    }
}

enum PodcastEntity: String, ItunesEntity {
    case podcastAuthor
    case podcast
    
    var entityName: String {
        return self.rawValue
    }
}

enum MusicVideoEntity: String, ItunesEntity {
    case musicArtist
    case musicVideo
    
    var entityName: String {
        return self.rawValue
    }
}

enum AudiobookEntity: String, ItunesEntity {
    case audiobookAuthor
    case audiobook
    
    var entityName: String {
        return self.rawValue
    }
}

enum ShortFilmEntity: String, ItunesEntity {
    case shortFilmArtist
    case shortFilm
    
    var entityName: String {
        return self.rawValue
    }
}

enum TVShowEntity: String, ItunesEntity {
    case tvEpisode
    case tvSeason
    
    var entityName: String {
        return self.rawValue
    }
}

enum SoftwareEntity: String, ItunesEntity {
    case software
    case iPadSoftware
    case macSoftware
    
    var entityName: String {
        return self.rawValue
    }
}

enum EbookEntity: String, ItunesEntity {
    case ebook
    
    var entityName: String {
        return self.rawValue
    }
}

enum AllEntity: String, ItunesEntity {
    case movie
    case album
    case allArtist
    case podcast
    case musicVideo
    case mix
    case audiobook
    case tvSeason
    case allTrack
    
    var entityName: String {
        return self.rawValue
    }
}
