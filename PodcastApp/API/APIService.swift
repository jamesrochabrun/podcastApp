//
//  APIService.swift
//  PodcastApp
//
//  Created by James Rochabrun on 6/1/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    // Singleton
    static let shared = APIService()
 
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
