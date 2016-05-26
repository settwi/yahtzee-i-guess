//
//  YahtzeeGameLogic.swift
//  yahtzee i guess
//
//  Created by Joseph Ehlert on 5/26/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import Foundation

enum YahtzeeLogicError: ErrorType {
    case RollError(Exception: String)
    case GameOverException(Exception: String)
}

class YahtzeeGameLogic {
    //Logic API for a Swift Yahtzee Game
    
    var dice: [SixSidedDie]
    var scoreCards: YahtzeeScoringCard
    var turn, playersGone, rollsRemaining, numPlayers: Int
    var gameOver: Bool
    
    init(numPlayers: Int) {
        let dice = [SixSidedDie(), SixSidedDie(), SixSidedDie(), SixSidedDie(), SixSidedDie()]
        for _ in 0..<numPlayers {
           scoreCards = YahtzeeScoringCard()
        }
        self.numPlayers = numPlayers
        var turn = 0
        var playersGone = 0
        var gameOver = false
        var rollsRemaining = 3
    }
    
    var intDice: [Int] {
        return dice.map({ $0.side })
        /*
        var newDice = [Int]()
        for d in dice {
            newDice.append(d.side)
        }
        return newDice
         */
        
    }
    
    var currentPlayer: Int {
        return turn + 1
    }
    
    var currentScoreCard: Int {
        return scoreCards(turn)
    }
    
    var potentialScores: Int {
        return scoreCards[turn].retrieveScores(intDice)
    }
    
    var numRounds: Int {
        return playersGone / numPlayers
    }
    
    func nextTurn(_: Int ) throws {
        if gameOver {
            throw YahtzeeLogicError.GameOverException(Exception: "Cannot switch turn; game over")
        }
        
        turn = (turn + 1) % numPlayers
        rollsRemaining = 3
        playersGone += 1
        
        if numRounds == 13 {
            gameOver = true
        }
    }
    
    func rollDice(whichDice: [Int]) -> [Int] {
        //whichDice: indices of dice to roll
        
        if rollsRemaining == 3 {
            
            return intDice
        }
    }
}










