//
//  BottomScoringCardView.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 6/1/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class BottomScoringCardView: ScoringCardView {
    // MARK: Properties
    @IBOutlet weak var scoringCardBottomButton: UIButton!
    @IBOutlet weak var bottomTotalButton: UIButton!
    
    @IBOutlet weak var threeOfAKindButton: ScoreButton!
    @IBOutlet weak var fourOfAKindButton: ScoreButton!
    @IBOutlet weak var fullHouseButton: ScoreButton!
    @IBOutlet weak var smStraightButton: ScoreButton!
    @IBOutlet weak var lgStraightButton: ScoreButton!
    @IBOutlet weak var yahtzeeButton: ScoreButton!
    @IBOutlet weak var chanceButton: ScoreButton!
    
    override func parentViewDidLoad(previouslyScored: [String: Int]) {
        threeOfAKindButton.scoreType = "3 of A Kind"
        fourOfAKindButton.scoreType = "4 of A Kind"
        fullHouseButton.scoreType = "Full House"
        smStraightButton.scoreType = "Small Straight"
        lgStraightButton.scoreType = "Large Straight"
        yahtzeeButton.scoreType = "YAHTZEE"
        chanceButton.scoreType = "Chance"
        
        scoreButtons = [
            threeOfAKindButton, fourOfAKindButton,
            fullHouseButton, smStraightButton, lgStraightButton,
            yahtzeeButton, chanceButton
        ]
        
        super.parentViewDidLoad(previouslyScored)
    }

    override func buttonFromScoreId(scoreId: String) -> ScoreButton? {
        switch scoreId {
        case threeOfAKindButton.scoreType:
            return threeOfAKindButton
        case fourOfAKindButton.scoreType:
            return fourOfAKindButton
        case fullHouseButton.scoreType:
            return fullHouseButton
        case smStraightButton.scoreType:
            return smStraightButton
        case lgStraightButton.scoreType:
            return lgStraightButton
        case yahtzeeButton.scoreType:
            return yahtzeeButton
        case chanceButton.scoreType:
            return chanceButton
        default:
            return nil
        }
    }
}
