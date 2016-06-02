//
//  TopScoringCardView.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 6/1/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit


class TopScoringCardView: ScoringCardView {
    // MARK: Properties
    @IBOutlet weak var scoringCardTopButton: UIButton!
    @IBOutlet weak var topTotalButton: UIButton!
    @IBOutlet weak var grandTotalButton: UIButton!

    @IBOutlet weak var onesButton: ScoreButton!
    @IBOutlet weak var twosButton: ScoreButton!
    @IBOutlet weak var threesButton: ScoreButton!
    @IBOutlet weak var foursButton: ScoreButton!
    @IBOutlet weak var fivesButton: ScoreButton!
    @IBOutlet weak var sixesButton: ScoreButton!
    
    override func parentViewDidLoad(previouslyScored: [String: Int]) {
        onesButton.scoreType = "Ones"
        twosButton.scoreType = "Twos"
        threesButton.scoreType = "Threes"
        foursButton.scoreType = "Fours"
        fivesButton.scoreType = "Fives"
        sixesButton.scoreType = "Sixes"
        
        scoreButtons = [
            onesButton, twosButton, threesButton,
            foursButton, fivesButton, sixesButton
        ]
        
        super.parentViewDidLoad(previouslyScored)
    }
    
    override func buttonFromScoreId(scoreId: String) -> ScoreButton? {
        switch scoreId {
        case onesButton.scoreType:
            return onesButton
        case twosButton.scoreType:
            return twosButton
        case threesButton.scoreType:
            return threesButton
        case foursButton.scoreType:
            return foursButton
        case fivesButton.scoreType:
            return fivesButton
        case sixesButton.scoreType:
            return sixesButton
        default:
            return nil
        }
    }
}
