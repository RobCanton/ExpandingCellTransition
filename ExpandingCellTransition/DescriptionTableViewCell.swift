//
//  DescriptionTableViewCell.swift
//  ExpandingCellTransition
//
//  Created by Robert Canton on 2017-09-17.
//  Copyright © 2017 Robert Canton. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
