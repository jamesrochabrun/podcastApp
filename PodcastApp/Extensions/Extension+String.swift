//
//  Extension+String.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/13/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

extension String {
    var secureHttps: String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
