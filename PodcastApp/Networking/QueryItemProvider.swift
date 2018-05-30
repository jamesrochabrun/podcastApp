//
//  QueryItemProvider.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

//conforming types of this prootcol must provide a queryItem
protocol QueryItemProvider {
    
    var queryItem: URLQueryItem { get }
}
