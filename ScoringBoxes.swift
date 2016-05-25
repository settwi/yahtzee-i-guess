//
//  ScoringBoxes.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 5/24/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import Foundation

class ScoringBox {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func scoreDice(dice: [Int]) -> Int {
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
    
    override func scoreDice(dice: [Int]) -> Int {
        return dice.filter({ $0 == self.numToScore }).reduce(0, combine: +)
    }
}

class NOfAKindScoringBox: ScoringBox {
    
    var ofAKind: Int
    
    init(name: String, ofAKind: Int) {
        self.ofAKind = ofAKind
        super.init(name: name)
    }
    
    override func scoreDice(dice: [Int]) -> Int {
        for die in dice {
            if dice.filter({ $0 == die }).count >= self.ofAKind {
                return dice.reduce(0, combine: +)
            }
        }
        
        return 0
    }
}

class ThreeOfAKindScoringBox: NOfAKindScoringBox {
    init(name: String) {
        super.init(name: name, 3)
    }
}

class FourOfAKindScoringBox: NOfAKindScoringBox {
    init(name:String) {
        super.init(name: name, 4)
    }
}

class FullHouseScoringBox: ScoringBox {
    init(name: String) {
        super.init(name: name)
    }
    
    override func scoreDice(dice:[Int]) -> Int {
        let first = dice[0]
        let numOfFirst = dice.filter({ $0 == first }).count
        
        if numOfFirst == 2 || numOfFirst == 3 {
            let numOfOther = 2
            if numOfFirst == 2 {
                numOfOther = 3
            }
            
            for  die in dice {
                if die != first && dice.filter({ $0 == die }).count == numOfOther {
                    return 25
                }
            }
        }
        
        return 0
    }
    
}

class SmallStraightScoringBox: ScoringBox {
    init(name: String) {
        super.init(name: name)
    }
    
    override func scoreDice(dice: [Int]) -> Int {
        let uniqueDice = Array(Set(dice)).sort()
        
        if uniqueDice.count < 4 {
            return 0
        }
        
        for i in 0..<3 {
            if uniqueDice[i+1] - uniqueDice[1] != 1 {
                return 0
            }
        }
        
        return 30
    }
}

class LargeStraightScoringBox: ScoringBox {
    init(name: String) {
        super.init(name: name)
    }
    
    override func scoreDice(dice: [Int]) -> Int {
        sortedDice = dice.sort()
        if sortedDice == [1, 2, 3, 4, 5] || sortedDice == [2, 3, 4, 5, 6] {
            return 40
        }
        
        return 0
    }
}

class YahtzeeScoringBox: ScoringBox {
    init(name: String) {
        super.init(name: name)
    }
    
    override func scoreDice(dice: [Int]) -> Int {
        if Set(dice).count != 1 {
            return 0
        }
        return 50
    }
}

class ChanceScoringBox: ScoringBox {
    // nothing to do here
}
