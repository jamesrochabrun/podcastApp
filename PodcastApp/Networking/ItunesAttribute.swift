//
//  ItunesAttribute.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

protocol ItunesAttribute: QueryItemProvider {
    
    //every conforming object to ItunesAttribute protocol have an attributeName
    var attributeName: String { get }
}

extension ItunesAttribute {
    
    //handling the QueryItemProvider required var
    var queryItem: URLQueryItem {
        return URLQueryItem(name: "attribute", value: attributeName)
    }
}

//////////////////////////////////////////////////////////////////
enum MovieAttribute: String {
    
    case actorTerm
    case genreIndex
    case artistTerm
    case shortFilmTerm
    case producerTerm
    case ratingTerm
    case directorTerm
    case releaseYearTerm
    case featureFilmTerm
    case movieArtistTerm
    case movieTerm
    case ratingIndex
    case descriptionTerm
}

extension MovieAttribute: ItunesAttribute {
    
    var attributeName: String {
        return self.rawValue
    }
}

//////////////////////////////////////////////////////////////////
enum PodcastAttribute: String{
    case titleTerm
    case languageTerm
    case authorTerm
    case genreIndex
    case artistTerm
    case ratingIndex
    case keywordsTerm
    case descriptionTerm
}

extension PodcastAttribute: ItunesAttribute {
    
    var attributeName: String {
        return self.rawValue
    }
}

//////////////////////////////////////////////////////////////////
enum MusicAttribute: String {
    case mixTerm
    case genreIndex
    case artistTerm
    case composerTerm
    case albumTerm
    case ratingIndex
    case songTerm
    
}

extension MusicAttribute: ItunesAttribute {
    
    var attributeName: String {
        return self.rawValue
    }
}

//////////////////////////////////////////////////////////////////
enum MusicVideoAttribute: String {
    case genreIndex
    case artistTerm
    case albumTerm
    case ratingIndex
    case songTerm
}

extension MusicVideoAttribute: ItunesAttribute {
    
    var attributeName: String {
        return self.rawValue
    }
}

//////////////////////////////////////////////////////////////////
enum AudiobookAttribute: String {
    case titleTerm
    case authorTerm
    case genreIndex
    case ratingIndex
}

extension AudiobookAttribute: ItunesAttribute {
    
    var attributeName: String {
        return self.rawValue
    }
}

//////////////////////////////////////////////////////////////////
enum ShortFilmAttribute: String {
    case genreIndex
    case artistTerm
    case shortFilmTerm
    case ratingIndex
    case descriptionTerm
    
}

extension ShortFilmAttribute: ItunesAttribute {
    
    var attributeName: String {
        return self.rawValue
    }
}

//////////////////////////////////////////////////////////////////
enum SoftwareAttribute: String {
    case softwareDeveloper
    
}

extension SoftwareAttribute: ItunesAttribute {
    
    var attributeName: String {
        return self.rawValue
    }
}

//////////////////////////////////////////////////////////////////
enum TVShowAttribute: String {
    case genreIndex
    case tvEpisodeTerm
    case showTerm
    case tvSeasonTerm
    case ratingIndex
    case descriptionTerm
    
    
}

extension TVShowAttribute: ItunesAttribute {
    
    var attributeName: String {
        return self.rawValue
    }
}

//////////////////////////////////////////////////////////////////
enum AllAttribute: String {
    case actorTerm
    case languageTerm
    case allArtistTerm
    case tvEpisodeTerm
    case shortFilmTerm
    case directorTerm
    case releaseYearTerm
    case titleTerm
    case featureFilmTerm
    case ratingIndex
    case keywordsTerm
    case descriptionTerm
    case authorTerm
    case genreIndex
    case mixTerm
    case allTrackTerm
    case artistTerm
    case composerTerm
    case tvSeasonTerm
    case producerTerm
    case ratingTerm
    case songTerm
    case movieArtistTerm
    case showTerm
    case movieTerm
    case albumTerm
    
}

extension AllAttribute: ItunesAttribute {
    
    var attributeName: String {
        return self.rawValue
    }
}
