//
//  YahtzeeScoringCard.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 5/25/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import Foundation


enum ScoringCardError: ErrorType {
    case AlreadyScoredBox
    case UnknownScoringBox
}


class YahtzeeScoringCard {
    // MARK: Scoring Card Properties
    var topBoxes, bottomBoxes: [String:ScoringBox]
    var topScores, bottomScores: [String:Int]
    var yahtzees: Int
    
    init() {
        yahtzees = 0
        
        topBoxes = [:]
        for (i, name) in ["Ones", "Twos", "Threes", "Fours", "Fives", "Sixes"].enumerate() {
            topBoxes[name] = NumScoringBox(name: name, numToScore: i + 1)
        }
        
        bottomBoxes = [
            "3 of A Kind":    ThreeOfAKindScoringBox(name: "3 of A Kind"),
            "4 of A Kind":    FourOfAKindScoringBox(name: "4 of A Kind"),
            "Full House":     FullHouseScoringBox(name: "Full House"),
            "Small Straight": SmallStraightScoringBox(name: "Small Straight"),
            "Large Straight": LargeStraightScoringBox(name: "Large Straight"),
            "Chance":         ChanceScoringBox(name: "Chance"),
            "YAHTZEE":        YahtzeeScoringBox(name: "YAHTZEE")
        ]
        
        topScores = [:]
        bottomScores = [:]
        // initialize to -1 to keep track of which have been scored
        for k in topBoxes.keys {
            topScores[k] = -1
        }
        for k in bottomBoxes.keys {
            bottomScores[k] = -1
        }
    }

    func retrieveScores(dice: [Int]) -> [[String:Int]] {
        var scorable: [[String:Int]] = [[:], [:]]
        
        for (k, box) in topBoxes {
            if topScores[k] == -1 {
                scorable[0][k] = box.scoreDice(dice) // dice dice, baby
            }
        }
        
        for (k, box) in bottomBoxes {
            if bottomScores[k] == -1 {
                scorable[1][k] = box.scoreDice(dice)
            }
            if k == "YAHTZEE" && bottomScores[k] != 0 {
                scorable[1][k] = box.scoreDice(dice)
            }
        }
        
        return scorable
    }
    
    func scoreRoll(dice: [Int], which: String) throws {
        let inTopBoxes = topBoxes.keys.contains(which)
        let scorable = retrieveScores(dice)
        let scorableSide = inTopBoxes ? scorable[0] : scorable[1]
        var score = topBoxes.keys.contains(which) ? topScores : bottomScores
        
        
        if let potentialScore = scorableSide[which] {
            if score[which] == -1 {
                score[which] = potentialScore
            }
            else if which == "YAHTZEE" {
                if score[which] == -1 {
                    score[which] = scorableSide[which]
                }
                else if score[which] != 0 {
                    score[which] = score[which]! + potentialScore
                    self.yahtzees += 1
                }
            }
            else {
                throw ScoringCardError.AlreadyScoredBox
            }
        }
        else {
            throw ScoringCardError.UnknownScoringBox
        }
    }
    
    func totalScore() -> [Int] {
        let topScore = topScores.values.filter({ $0 != -1 }).reduce(0, combine: +)
        let bottomScore = bottomScores.values.filter({ $0 != -1 }).reduce(0, combine: +)
        let topBonus = topScore >= 63 ? 35 : 0
        let yahtzeeBonus = 100 * max(0, yahtzees - 1)
        
        return [topScore, topBonus, bottomScore, yahtzeeBonus]
    }
    
}
