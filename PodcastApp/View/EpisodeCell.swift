//
//  EpisodeCell.swift
//  PodcastApp
//
//  Created by James Rochabrun on 6/26/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class EpisodeCell: UITableViewCell {
    
    @IBOutlet private weak var episodeLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var episodeImageView: UIImageView!
    
    
    func configure(viewModel: EpisodeViewModel) {
        
        episodeLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        dateLabel.text = "episode Date \(viewModel.date.description)"
//
//        guard let url = URL(string: viewModel.thumbnailArtworkUrl) else { return }
//        podcastImageView.sd_setImage(with: url, placeholderImage: nil)
    }
}
