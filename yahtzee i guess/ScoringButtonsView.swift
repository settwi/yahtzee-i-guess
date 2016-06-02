//
//  ScoringButtonsView.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 5/31/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class ScoringButtonsView: UIView {
    // MARK: Properties
    
    var containingStackView: UIStackView
    var firstSectionStackView: UIStackView
    var secondSectionStackView: UIStackView
    var firstButtons = [UIButton]()
    var secondButtons = [UIButton]()
    
    let firstButtonNames = [
        "Ones", "Twos", "Threes", "Fours",
        "Fives", "Sixes", "Roll"
    ]
    let secondButtonNames = [
        "Three of A Kind", "Four of A Kind", "Full House",
        "Small Straight", "Large Straight", "Yahtzee",
        "Chance"
    ]
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        
        var tag = 0
        // go from in to out
        firstButtons = firstButtonNames.map({ (name: String) in
            let button = UIButton(type: .System)
            button.setTitle(name, forState: .Normal)
            button.tag = tag
            tag += 1
            return button
        })
        
        secondButtons = secondButtonNames.map({ (name: String) in
            let button = UIButton(type: .System)
            button.setTitle(name, forState: .Normal)
            button.tag = tag
            tag += 1
            return button
        })
        
        firstSectionStackView = UIStackView(arrangedSubviews: firstButtons)
        secondSectionStackView = UIStackView(arrangedSubviews: secondButtons)
        let innerStackViews = [firstSectionStackView, secondSectionStackView]
        for view in innerStackViews {
            view.spacing = 3
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .Vertical
            view.alignment = .Fill
            view.distribution = .Fill
        }
        
        containingStackView = UIStackView(arrangedSubviews: innerStackViews)
        containingStackView.axis = .Horizontal
        containingStackView.alignment = .Center
        containingStackView.distribution = .FillEqually
        
        super.init(coder: aDecoder)
        addSubview(containingStackView)
    }
    
    func displayScorecard() {
        
    }
    
}
