//
//  SixSidedDie.swift
//  yahtzee i guess
//
//  Created by Joseph Ehlert on 5/23/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import Darwin

class SixSidedDie {
    var side: Int
    
    init() {
        side = Int(arc4random_uniform(6) + 1)
    }
    
    func roll() -> Int {
        side = Int(arc4random_uniform(6) + 1)
        return side
    }
}
