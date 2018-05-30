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
    
    func configure(viewModel: PodcastViewModel) {
        self.textLabel?.text = "\(viewModel.artistDisplayName)\n\(viewModel.displayName)"
        self.textLabel?.numberOfLines = -1 //inifinite number of lines
        self.imageView?.image = #imageLiteral(resourceName: "appicon")
    }
}



