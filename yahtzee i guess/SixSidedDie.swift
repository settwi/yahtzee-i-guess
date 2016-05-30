//
//  SixSidedDie.swift
//  yahtzee i guess
//
//  Created by Joseph Ehlert on 5/23/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import Foundation

class SixSidedDie: NSObject, NSCoding {
    var side: Int
    
    override init() {
        side = Int(arc4random_uniform(6) + 1)
        super.init()
    }
    
    func roll() -> Int {
        side = Int(arc4random_uniform(6) + 1)
        return side
    }
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        let side = aDecoder.decodeIntegerForKey("side")
        self.side = side
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(side, forKey: "side")
    }
}
