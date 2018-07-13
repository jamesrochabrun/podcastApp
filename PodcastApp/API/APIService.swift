//
//  APIService.swift
//  PodcastApp
//
//  Created by James Rochabrun on 6/1/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    // Singleton
    static let shared = APIService()
    
    func fetchEpisodes(feedUrl: URL, completion: @escaping ([Episode]) -> ()) {
        
        let parser = FeedParser(URL: feedUrl)
        parser.parseAsync { (result) in
            
            if let err = result.error {
                print("the error is!!!, \(err)")
                return
            }
            guard let feed = result.rssFeed else { return }
            DispatchQueue.main.async {
                completion(feed.toEpisodes())
            }
        }
    }
 
    func fetchPodcasts(searchText: String, completion: @escaping ([Podcast]) -> () ) {
        
        let urlDummy = "https://itunes.apple.com/search"
        let params = ["term": searchText,
                      "media": "podcast"]
        
        Alamofire.request(urlDummy, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print("Failed to connect --- \(error)")
                return
            }
            guard let data = dataResponse.data else { return }
            
            do {
                let searchResults = try JSONDecoder().decode(SearchResults.self, from: data)
                completion(searchResults.results)
                
            } catch let decodeError {
                print("Failed to decode --- \(decodeError)")
            }
        }
    }
}
