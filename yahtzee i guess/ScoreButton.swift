//
//  ScoreButton.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 6/1/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class ScoreButton: UIButton {
    var scoreType: String!
    var boxScored: Bool = false
    var defaultColor: UIColor?
    
    func solidifyScoreForRound() {
        boxScored = true
        if currentTitleColor != UIColor.redColor() {
            defaultColor = currentTitleColor
        }
        alpha = 1
        setTitleColor(UIColor.redColor(), forState: [.Normal, .Disabled])
    }
    
    func prepareForNewTurn() {
        boxScored = false
        setTitleColor(defaultColor, forState: [.Normal, .Disabled])
    }
}