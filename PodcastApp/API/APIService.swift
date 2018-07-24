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
        
        DispatchQueue.global(qos: .background).async {
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
    
    /// Downloading logic
    func download(episode: Episode) {
        
        guard let streamUrl = episode.streamUrl else { return }
        
        /// Saving in file
        let downloadReq = DownloadRequest.suggestedDownloadDestination()
        
        Alamofire.download(streamUrl, to: downloadReq).downloadProgress { progress in
            print("pro \(progress.fractionCompleted)")
            }.response { (response) in
                
                /// 1. getAll the downloaded episodes
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                
                /// 2. get the index of the episode that want to download
                guard let index = downloadedEpisodes.index(where: {
                    $0.title == episode.title && $0.author == episode.author
                }) else { return }
                /// 3. set the file Url that we will use to access the episode
                downloadedEpisodes[index].fileUrl = response.destinationURL?.absoluteString ?? "No provided"
                do {
                    
                    /// 4. update the storage with the fileUrl property for that episode.
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
                } catch let err {
                    print("Error on encoding episode wit error = \(err)")
                }
        }
    }
}














