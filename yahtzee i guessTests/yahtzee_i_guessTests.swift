//
//  yahtzee_i_guessTests.swift
//  yahtzee i guessTests
//
//  Created by William Setterberg on 5/20/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import XCTest
@testable import yahtzee_i_guess

class yahtzee_i_guessTests: XCTestCase {
    
    // todo: only allow one turn
    func testYahtzeeLogic() {
        let gameLogic = YahtzeeGameLogic(playersThisGame: 1)
        do {
            try gameLogic.rollDice([1, 2, 3, 4, 5])
        } catch {
            print("gameLogic.rollDice: \(error)")
        }
        
        if gameLogic.intDice.contains(1) {
            do {
                try gameLogic.scoreRoll("Ones")
                print("scored ones")
            } catch {
                print("gameLogic.scoreRoll: \(error)")
            }
        }
        else {
            print("there aren't any ones in this")
        }
        
        let hackDie = SixSidedDie()
        hackDie.side = 4
        gameLogic.dice = (0..<5).map({ (_: Int) in hackDie })
        try! gameLogic.nextTurn()
        if let _ = (try? gameLogic.rollDice([0, 1, 2, 3, 4])) {
            do {
                try gameLogic.scoreRoll("YAHTZEE")
                print("scored a yahtzee")
            } catch {
                print("score yahtzee: \(error)")
            }
        }
    }
    
}
