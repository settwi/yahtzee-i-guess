//
//  YahtzeeGameLogic.swift
//  yahtzee i guess
//
//  Created by Joseph Ehlert on 5/26/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import Foundation

enum YahtzeeLogicError: ErrorType {
    case UnusableDiceProvided
    case RollAtLeastOnceToScore
    case OnlyRollThreeTimes
    case AlreadyScoredThisTurn
    case GameOver
}

class YahtzeeGameLogic {
    // Logic API for a Swift Yahtzee Game
    
    var dice: [SixSidedDie]
    var scoreCards: [YahtzeeScoringCard]
    var turn, playersGone, rollsRemaining, numPlayers: Int
    var gameOver, scoredThisTurn: Bool
    
    var currentPlayer: Int { return turn + 1 }
    var numRounds: Int { return playersGone / numPlayers }
    var currentScoreCard: YahtzeeScoringCard { return scoreCards[turn] }
    var potentialScores: [[String:Int]] { return currentScoreCard.retrieveScores(intDice) }
    var intDice: [Int] { return dice.map({ $0.side }) }
    
    init(playersThisGame: Int) {
        // generate 5 dice nicely
        dice = (0..<5).map({ (_: Int) in SixSidedDie() })
        
        // generate playersThisGame scoring cards nicely
        scoreCards = (0..<playersThisGame).map({ (_: Int) in YahtzeeScoringCard() })

        numPlayers = playersThisGame
        turn = 0
        playersGone = 0
        gameOver = false
        scoredThisTurn = false
        rollsRemaining = 3
    }
    
    func nextTurn() throws {
        if gameOver {
            throw YahtzeeLogicError.GameOver
        }
        
        turn = (turn + 1) % numPlayers
        scoredThisTurn = false
        rollsRemaining = 3
        playersGone += 1
        
        if numRounds == 13 {
            gameOver = true
        }
    }
    
    func rollDice(whichDice: [Int]) throws {
        // whichDice: indices of dice to roll
        
        if whichDice.count == 0 {
            throw YahtzeeLogicError.UnusableDiceProvided
        }
        if rollsRemaining == 0 {
            throw YahtzeeLogicError.OnlyRollThreeTimes
        }
        if gameOver {
            throw YahtzeeLogicError.GameOver
        }
        if scoredThisTurn {
            throw YahtzeeLogicError.AlreadyScoredThisTurn
        }
        
        let diceToRoll = rollsRemaining == 3 ? [0, 1, 2, 3, 4] : whichDice
        for i in diceToRoll {
            if dice.indices.contains(i) {
                dice[i].roll()
            } else {
                throw YahtzeeLogicError.UnusableDiceProvided
            }
        }

        rollsRemaining -= 1
    }

    func scoreRoll(which: String) throws {
        // which: the roll to score
        
        if rollsRemaining == 3 {
            throw YahtzeeLogicError.RollAtLeastOnceToScore
        }
        if scoredThisTurn {
            throw YahtzeeLogicError.AlreadyScoredThisTurn
        }
        
        try currentScoreCard.scoreRoll(intDice, which: which)
        scoredThisTurn = true
    }
}










