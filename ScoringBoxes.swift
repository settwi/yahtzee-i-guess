//
//  ScoringBoxes.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 5/24/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

class ScoringBox {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func score_dice(dice: [Int]) -> Int {
        // same as chance
        return dice.reduce(0, combine: +)
    }
}

class NumScoringBox: ScoringBox {
    
    var numToScore: Int
    
    init(name: String, numToScore: Int) {
        self.numToScore = numToScore
        super.init(name: name)
    }
    
    override func score_dice(dice: [Int]) -> Int {
        return dice.filter({ $0 == self.numToScore }).reduce(0, combine: +)
    }
}

class NOfAKindScoringBox: ScoringBox {
    
    var ofAKind: Int
    
    init(name: String, ofAKind: Int) {
        self.ofAKind = ofAKind
        super.init(name: name)
    }
    
    override func score_dice(dice: [Int]) -> Int {
        for die in dice {
            if dice.filter({ $0 == die }).count >= self.ofAKind {
                return dice.reduce(0, combine: +)
            }
        }
        
        return 0
    }
}

