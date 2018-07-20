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

    // MARK:- Properties
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    
    // MARK:- UI
    var playerDetailsView = PlayerDetailsView.initFromNib()

    // MARK:- App lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppereance()
        setNavControllers()
        setUpPlayerDetailsView()
    }
    
    // MARK:- UI functions
    fileprivate func setAppereance() {
        tabBar.tintColor = .purple
        UINavigationBar.appearance().prefersLargeTitles = true
    }
    
    @objc func minimizePlayerDetails() {

        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.playerDetailsView?.maximizedStackview.alpha = 0
            self.playerDetailsView?.miniPlayerView.alpha = 1
        })
    }
    
    func maximizePlayerDetails(with episode: Episode?) {
        
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false
        
        guard let episode = episode else { return }
        playerDetailsView?.episode = episode
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.playerDetailsView?.maximizedStackview.alpha = 1
            self.playerDetailsView?.miniPlayerView.alpha = 0
        })
    }
    
    private func setUpPlayerDetailsView() {
        
        guard let playerDetailsView = self.playerDetailsView else { return }
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        NSLayoutConstraint.activate([
            
            maximizedTopAnchorConstraint,
            playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
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




