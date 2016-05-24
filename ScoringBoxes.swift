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
    
    override func score_dice(dice:[Int]) -> Int {
        let first = dice[0]
        let num_of_first = dice.filter({ $0 == first }).count
        
        if num_of_first == 2 || num_of_first == 3 {
            let num_of_other = 2
            if num_of_first == 2 {
                num_of_other = 3
            }
            
            for  die in dice {
                if die != first && dice.filter({ $0 == die }).count == num_of_other {
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
    
    override func score_dice(dice: [Int]) -> Int {
        let unique_dice = dice.sort()
        
        if unique_dice.count < 4 {
            return 0
        }
        
        for i in 0..<3 {
            if unique_dice[i + 1] - unique_dice[1] != 1 {
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
    
    override func score_dice(dice: [Int]) -> Int {
        sorted_dice = dice.sort()
        if sorted_dice == [1, 2, 3, 4, 5] || sorted_dice == [2, 3, 4, 5, 6] {
            return 40
        }
        
        return 0
    }
}

class YahtzeeScoringBox: ScoringBox {
    init(name: String) {
        super.init(name: name)
    }
    
    override func score_dice(dice: [Int]) -> Int {
        
    }
}




