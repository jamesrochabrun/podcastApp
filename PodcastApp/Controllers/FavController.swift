//
//  FavController.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class FavController: UICollectionViewController {
    
    // MARK:- Private properties
    private var collectionDataSource: CollectionViewDataSource<FavoriteCell, Podcast>?
    
    // MARK:- App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpDataSource()
        UIApplication.mainTabBarController?.favoriteNav?.tabBarItem.badgeValue = nil
    }
    
    // MARK:- Set Up UI
    private func setUpCollectionView() {
        self.collectionView?.backgroundColor = .white
        self.collectionView?.register(FavoriteCell.self)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handelLongPress))
        self.collectionView?.addGestureRecognizer(longPress)
    }
    
    private func setUpDataSource() {
        
        let favoritePodcasts = UserDefaults.standard.savedPodcasts()
        collectionDataSource = CollectionViewDataSource(models: favoritePodcasts) { cell, model in
            let vm = FavoriteCellViewmodel(model)
            cell.configure(with: vm)
            return cell
        }
        self.collectionView?.dataSource = collectionDataSource
        self.collectionView?.reloadData()
    }
    
    // MARK:- Actions
    @objc func handelLongPress(gesture: UILongPressGestureRecognizer) {
        
        let point = gesture.location(in: self.collectionView)
        guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: point) else { return }
        let alertController = UIAlertController(title: "Remoce", message: "Podcast?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (_) in
            self.updateDataFrom(indexPath: selectedIndexPath)

        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        present(alertController, animated: true)
    }
    
    private func updateDataFrom(indexPath: IndexPath) {
        
        if let podcastToRemove = self.collectionDataSource?.object(at: indexPath) {
            UserDefaults.standard.removePodcast(podcastToRemove)
        }
        self.collectionDataSource?.removeItem(at: indexPath)
        self.collectionView?.performBatchUpdates({
            self.collectionView?.deleteItems(at: [indexPath])
            
        })
    }
}

extension FavController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 3 * 16) / 2
        let height = width + 46
        return CGSize(width: width, height: height)
    }
    
    ///  Adding padding to the borders - insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

// MARK:- UICollectionViewDelegate
extension FavController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        episodesController.podcast = self.collectionDataSource?.object(at: indexPath)
        navigationController?.pushViewController(episodesController, animated: true)
    }
}









