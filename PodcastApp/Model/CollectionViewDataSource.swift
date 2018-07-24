//
//  CollectionViewDataSource.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/23/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

/// This class is a simple, immutable, declarative data source for UITableView
final class CollectionViewDataSource<V, T> : NSObject, UICollectionViewDataSource where V: UICollectionViewCell {
    
    private var models: [T]
    private let configureCell: CellConfiguration
    typealias CellConfiguration = (V, T) -> V
    
    var count: Int {
        return self.models.count
    }
    
    var isEmpty: Bool {
        return self.models.isEmpty
    }
    
    init(models: [T], configureCell: @escaping CellConfiguration) {
        self.models = models
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: V = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let model = models[indexPath.row]
        return configureCell(cell, model)
    }

    
    /// MARK: updates for search
    func update(models: [T]) {
        self.models = models
    }
    
    func object(at indexPath: IndexPath) -> T {
        return self.models[indexPath.item]
    }
    
    func removeItem(at indexPath: IndexPath) {
        self.models.remove(at: indexPath.item)
    }
}

