//
//  ScoringCardView.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 6/1/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class ScoringCardView: UIStackView {
    var scoreButtons: [ScoreButton] = []
    
    func parentViewDidLoad(previouslyScored: [String: Int]) {
        resetAllButtonsForNewTurn()
        modifyButtonsForAlreadyScored(previouslyScored)
    }
    
    func resetAllButtonsForNewTurn() {
        for button in scoreButtons {
            button.prepareForNewTurn()
        }
    }
    
    func modifyButtonsForAlreadyScored(previouslyScored: [String: Int]) {
        for button in scoreButtons {
            button.boxScored = false
            if previouslyScored.keys.contains(button.scoreType) {
                button.solidifyScoreForRound()
                button.enabled = false
            }
        }
    }
    
    func toggleButtonsEnabledState(enabled: Bool) {
        for button in scoreButtons {
            if !button.boxScored {
                button.alpha = enabled ? CGFloat(1) : CGFloat(0.4)
                button.enabled = enabled
            }
            else {
                button.solidifyScoreForRound()
                button.enabled = false
            }
        }
    }
    
    func buttonFromScoreId(scoreId: String) -> ScoreButton? {
        // incomplete implementation
        return nil
    }
    
    func updateButtonTitlesFromNewScores(scores: [String: Int], previouslyScored: [String: Int]) {
        resetAllButtonsForNewTurn()
        modifyButtonsForAlreadyScored(previouslyScored)
        for button in scoreButtons {
            if previouslyScored.keys.contains(button.scoreType) {
                button.setTitle("\(button.scoreType) - \(previouslyScored[button.scoreType]!)",
                                forState: [.Normal, .Disabled])
                button.enabled = false
            }
            else {
                button.setTitle(button.scoreType, forState: [.Normal, .Disabled])
            }
        }
        
        if !scores.isEmpty {
            for (scoreId, scoreVal) in scores {
                let buttonToScore = buttonFromScoreId(scoreId)
                if let button = buttonToScore {
                    button.setTitle("\(scoreId) - \(scoreVal)", forState: .Normal)
                    if button.boxScored || previouslyScored.keys.contains(button.scoreType) {
                        button.setTitle("\(button.scoreType) - \(previouslyScored[button.scoreType]!)",
                                        forState: [.Normal, .Disabled])
                        button.enabled = false
                        button.solidifyScoreForRound()
                    }
                }
            }
        }
    }
}
