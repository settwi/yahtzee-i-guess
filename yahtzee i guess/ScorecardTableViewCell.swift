//
//  ScorecardTableViewCell.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 5/30/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class ScorecardTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var scoreTypeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
