//
//  SectionDividerTableViewCell.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 5/31/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class SectionDividerTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel! // only fill if there is a score associated with this...
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
