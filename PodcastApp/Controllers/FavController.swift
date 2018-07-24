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
    private var collectionDataSource: CollectionViewDataSource<FavoriteCell, Episode>?
    
    // MARK:- App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    // MARK:- Set Up UI
    private func setUpCollectionView() {
        self.collectionView?.register(FavoriteCell.self)
    }
    
    private func setUpDataSource(with models: [Episode]) {
        
        collectionDataSource = CollectionViewDataSource(models: models) { cell, model in
            //    let vModel = EpisodeCellViewModel(model: model)
            //    cell.configure(viewModel: vModel)
            return cell
        }
        self.collectionView?.dataSource = collectionDataSource
        self.collectionView?.reloadData()
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









