//
//  PodcastCell.swift
//  PodcastApp
//
//  Created by James Rochabrun on 5/29/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var podcastLabel: UILabel!
    @IBOutlet weak var podcastCountLabel: UILabel!
    @IBOutlet weak var podcastImageView: UIImageView!
    
    
    func configure(viewModel: PodcastViewModel) {
        
        trackNameLabel.text = viewModel.displayName
        podcastLabel.text = viewModel.artistDisplayName
        self.podcastImageView.image = #imageLiteral(resourceName: "appicon")
    }
}



