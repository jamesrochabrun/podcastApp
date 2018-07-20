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
    
    @IBOutlet private weak var episodeLabel: UILabel! {
        didSet {
            episodeLabel.numberOfLines = 2
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var episodeImageView: UIImageView!
    
    
    func configure(viewModel: EpisodeCellViewModel) {
        
        episodeLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        dateLabel.text = "\(viewModel.date.description)"
        guard let thumbnailUrl = viewModel.episodeThumbnailUrl else { return }
        episodeImageView.sd_setImage(with: thumbnailUrl)
    }
}







