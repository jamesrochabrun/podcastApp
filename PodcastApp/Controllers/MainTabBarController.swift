//
//  MainTabBarController.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {

    // MARK:- App lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppereance()
        setNavControllers()
    }
    
    // MARK:- UI functions
    fileprivate func setAppereance() {
        tabBar.tintColor = .purple
        UINavigationBar.appearance().prefersLargeTitles = true
    }
    
    // MARK:- Set up Functions
    fileprivate func setNavControllers() {
        
        let searchNavController = generateNavController(root: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search"))
        let favNavController = generateNavController(root: FavController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites"))
        let downloadNavController = generateNavController(root: DownloadController(), title: "Download", image: #imageLiteral(resourceName: "downloads"))
        viewControllers = [searchNavController, favNavController, downloadNavController]
    }
    
    // MARK:- Helper Functions
    private func generateNavController(root: UIViewController, title: String, image: UIImage?) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: root)
        root.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}




