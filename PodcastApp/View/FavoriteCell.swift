//
//  FavoriteCell.swift
//  PodcastApp
//
//  Created by James Rochabrun on 7/23/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class FavoriteCell: UICollectionViewCell {
    
    let artworkImageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
    let nameLabel = UILabel()
    let artistLabel = UILabel()
    
    // MARK:- App Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK:- Setup UI
    func setUpUI() {
        
        let stackView = UIStackView(arrangedSubviews: [artworkImageView, nameLabel, artistLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            artworkImageView.heightAnchor.constraint(equalTo: artworkImageView.widthAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    // MARK:- Setup UI
    func configure(with viewModel: FavoriteCellViewmodel) {
        self.artistLabel.text = viewModel.artistName
        self.nameLabel.text = viewModel.trackName
        guard let url = viewModel.artworkUrl else { return }
        self.artworkImageView.sd_setImage(with: url)
    }
}

struct FavoriteCellViewmodel {
    
    let artistName: String
    let trackName: String
    let artworkUrl: URL?
    
    init(_ model: Podcast) {
        self.artistName = model.artistName ?? "No artist name"
        self.trackName = model.trackName ?? "No trackname"
        self.artworkUrl = URL(string: model.artworkUrl600 ?? "")
    }
}




