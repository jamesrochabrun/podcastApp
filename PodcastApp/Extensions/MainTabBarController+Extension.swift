//
//  MainTabBarController+Extension.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/24/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

extension MainTabBarController {
    
    var favoriteNav: UINavigationController? {
        guard let index = self.viewControllers?.index(where: { vc in
            let navVC = vc as? UINavigationController
            return navVC?.tabBarItem.title == "Favorites"
        }) else { return nil }
        return self.viewControllers?[index] as? UINavigationController
    }
}

extension UINavigationController {
    
    var root: UIViewController? {
        return viewControllers.first
    }
}
