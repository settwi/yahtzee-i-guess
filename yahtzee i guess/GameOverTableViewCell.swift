//
//  GameOverTableViewCell.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 6/3/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class GameOverTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var topScoreLabel: UILabel!
    @IBOutlet weak var topBonusLabel: UILabel!
    @IBOutlet weak var bottomScoreLabel: UILabel!
    @IBOutlet weak var yahtzeeBonusLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
