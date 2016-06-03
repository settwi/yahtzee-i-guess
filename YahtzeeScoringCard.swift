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


class YahtzeeScoringCard: NSObject, NSCoding {
    // MARK: Properties
    var topBoxes, bottomBoxes: [String: ScoringBox]
    var topScores, bottomScores: [String: Int]
    var yahtzeeBonuses: Int
    
    // MARK: Types
    struct PropertyKey {
        static let yahtzeesKey = "yahtzeeBonuses"
        static let topBoxesKey = "topBoxes"
        static let bottomBoxesKey = "bottomBoxes"
        static let topScoresKey = "topScores"
        static let bottomScoresKey = "bottomScores"
    }
    
    override init() {
        yahtzeeBonuses = 0
        
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
        
        super.init()
    }

    func retrieveScores(dice: [Int]) -> [[String: Int]] {
        var scorable: [[String: Int]] = [[:], [:]]
        
        for (k, box) in topBoxes {
            if topScores[k] == -1 {
                scorable[0][k] = box.scoreDice(dice) // dice dice, baby
            }
        }
        
        for (k, box) in bottomBoxes {
            if bottomScores[k] == -1 {
                scorable[1][k] = box.scoreDice(dice)
            }
        }
        
        return scorable
    }
    
    func scoreRoll(dice: [Int], which: String) throws {
        let inTopBoxes = topBoxes.keys.contains(which)
        let scorable = retrieveScores(dice)
        let scorableSide = inTopBoxes ? scorable[0] : scorable[1]
        
        
        if topBoxes.keys.contains(which) {
            if topScores[which] == -1 {
                topScores[which] = scorableSide[which]!
            }
            else {
                throw ScoringCardError.AlreadyScoredBox
            }
        }
            
        else if bottomBoxes.keys.contains(which) {
            if bottomScores[which] == -1 {
                bottomScores[which] = scorableSide[which]!
            }
            else {
                throw ScoringCardError.AlreadyScoredBox
            }
        }
        else {
            throw ScoringCardError.UnknownScoringBox
        }

        if which != "YAHTZEE" && bottomScores["YAHTZEE"] != 0 && bottomBoxes["YAHTZEE"]!.scoreDice(dice) != 0 {
            yahtzeeBonuses += 1
        }
    }
    
    func totalScore() -> [Int] {
        let topScore = topScores.values.filter({ $0 != -1 }).reduce(0, combine: +)
        let bottomScore = bottomScores.values.filter({ $0 != -1 }).reduce(0, combine: +)
        let topBonus = topScore >= 63 ? 35 : 0
        let yahtzeeBonus = 100 * yahtzeeBonuses
        
        return [topScore, topBonus, bottomScore, yahtzeeBonus]
    }
    
    required init(coder aDecoder: NSCoder) {
        topBoxes = aDecoder.decodeObjectForKey(
            PropertyKey.topBoxesKey) as! [String: ScoringBox]
        bottomBoxes = aDecoder.decodeObjectForKey(
            PropertyKey.bottomBoxesKey) as! [String: ScoringBox]
        yahtzeeBonuses = aDecoder.decodeIntegerForKey(PropertyKey.yahtzeesKey)
        topScores = aDecoder.decodeObjectForKey(PropertyKey.topScoresKey) as! [String: Int]
        bottomScores = aDecoder.decodeObjectForKey(PropertyKey.bottomScoresKey) as! [String: Int]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(topBoxes, forKey: PropertyKey.topBoxesKey)
        aCoder.encodeObject(bottomBoxes, forKey: PropertyKey.bottomBoxesKey)
        aCoder.encodeObject(topScores, forKey: PropertyKey.topScoresKey)
        aCoder.encodeObject(bottomScores, forKey: PropertyKey.bottomScoresKey)
        aCoder.encodeInteger(yahtzeeBonuses, forKey: PropertyKey.yahtzeesKey)
    }
    
}
