//
//  UIApplication+Extension.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/19/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    static var mainTabBarController: MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
