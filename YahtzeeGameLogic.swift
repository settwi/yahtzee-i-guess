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

extension YahtzeeLogicError {
    var description: String {
        switch self {
            case .UnusableDiceProvided: return "Pick appropriate dice"
            default: return String(self)
        }
    }
}

class YahtzeeGameLogic: NSObject, NSCoding {
    // MARK: Properties
    var dice: [SixSidedDie]
    var scoreCards: [YahtzeeScoringCard]
    var turn, playersGone, rollsRemaining, numPlayers: Int
    var gameOver, scoredThisTurn: Bool
    
    var currentPlayer: Int { return turn + 1 }
    var numRounds: Int { return playersGone / numPlayers }
    var currentScoreCard: YahtzeeScoringCard { return scoreCards[turn] }
    var currentTotalScore: [Int] { return currentScoreCard.totalScore() }   // todo: make a property
    var potentialScores: [[String:Int]] {
        return rollsRemaining == 3 ? [[:], [:]] :
            currentScoreCard.retrieveScores(intDice)
    }
    var intDice: [Int] { return dice.map({ $0.side }) }
    var boxesAlreadyScoredForCurrentCard: [String: Int] {
        var topScored = currentScoreCard.topScores
        for (k, v) in topScored {
            if v == -1 {
                topScored.removeValueForKey(k)
            }
        }
        
        var bottomScored = currentScoreCard.bottomScores
        for (k, v) in bottomScored {
            if v == -1 {
                bottomScored.removeValueForKey(k)
            }
        }
        
        var finalScored = topScored
        for (k, v) in bottomScored { finalScored[k] = v }
        
        return finalScored
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(
        .DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("yahtzee")
    
    // MARK: Types
    struct PropertyKey {
        static let diceKey = "dice"
        static let scoreCardsKey = "scoreCards"
        static let numPlayersKey = "numPlayers"
        static let turnKey = "turn"
        static let playersGoneKey = "playersGone"
        static let scoredThisTurnKey = "scoredThisTurn"
        static let gameOverKey = "gameOver"
        static let rollsRemainingKey = "rollsRemaining"
    }
    
    // MARK: Initialization
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
            throw YahtzeeLogicError.GameOver
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
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(dice, forKey: PropertyKey.diceKey)
        aCoder.encodeObject(scoreCards, forKey: PropertyKey.scoreCardsKey)
        aCoder.encodeInteger(numPlayers, forKey: PropertyKey.numPlayersKey)
        aCoder.encodeInteger(turn, forKey: PropertyKey.turnKey)
        aCoder.encodeInteger(playersGone, forKey: PropertyKey.playersGoneKey)
        aCoder.encodeInteger(rollsRemaining, forKey: PropertyKey.rollsRemainingKey)
        aCoder.encodeBool(scoredThisTurn, forKey: PropertyKey.scoredThisTurnKey)
        aCoder.encodeBool(gameOver, forKey: PropertyKey.gameOverKey)
        // wow that's a mouthful
    }
    
    required init?(coder aDecoder: NSCoder) {
        dice = aDecoder.decodeObjectForKey(PropertyKey.diceKey) as! [SixSidedDie]
        scoreCards = aDecoder.decodeObjectForKey(PropertyKey.scoreCardsKey) as! [YahtzeeScoringCard]
        numPlayers = aDecoder.decodeIntegerForKey(PropertyKey.numPlayersKey)
        turn = aDecoder.decodeIntegerForKey(PropertyKey.turnKey)
        playersGone = aDecoder.decodeIntegerForKey(PropertyKey.playersGoneKey)
        rollsRemaining = aDecoder.decodeIntegerForKey(PropertyKey.rollsRemainingKey)
        scoredThisTurn = aDecoder.decodeBoolForKey(PropertyKey.scoredThisTurnKey)
        gameOver = aDecoder.decodeBoolForKey(PropertyKey.gameOverKey)
        // also a mouthful
        // and a waste of time
        // whatever
    }
}










