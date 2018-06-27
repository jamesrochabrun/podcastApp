//
//  PodcastCell.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var podcastLabel: UILabel!
    @IBOutlet private weak var podcastCountLabel: UILabel!
    @IBOutlet private  var podcastImageView: UIImageView!
    
    
    func configure(viewModel: PodcastViewModel) {
        
        trackNameLabel.text = viewModel.displayName
        podcastLabel.text = viewModel.artistDisplayName
        podcastCountLabel.text = viewModel.episodeCount
        
        guard let url = URL(string: viewModel.thumbnailArtworkUrl) else { return }
        podcastImageView.sd_setImage(with: url, placeholderImage: nil)
    }
}



