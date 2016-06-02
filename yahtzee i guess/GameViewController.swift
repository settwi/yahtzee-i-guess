//
//  GameViewController.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 5/27/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var rollButton: UIButton!
    @IBOutlet weak var topScoringCard: TopScoringCardView!
    @IBOutlet weak var bottomScoringCard: BottomScoringCardView!
    @IBOutlet weak var diceView: SelectDiceView!
    @IBOutlet weak var nextTurnButton: UIBarButtonItem!
    var gameLogic: YahtzeeGameLogic!             // implicitly unwrapped to avoid initializer loll
    var numPlayers: Int = 0
    
    override func viewDidLoad() {
        nextTurnButton.enabled = false
        diceView.updateDiceImagesFromYahtzeeDice(gameLogic.intDice)
        topScoringCard.parentViewDidLoad(gameLogic.boxesAlreadyScoredForCurrentCard)
        bottomScoringCard.parentViewDidLoad(gameLogic.boxesAlreadyScoredForCurrentCard)
        updateScoreCardsFromPotentialScores()

        if !gameLogic.scoredThisTurn {
            if gameLogic.rollsRemaining == 3 {
                diceView.toggleButtonEnabledState(false)
                topScoringCard.toggleButtonsEnabledState(false)
                bottomScoringCard.toggleButtonsEnabledState(false)
            }
            else if gameLogic.rollsRemaining == 0 {
                diceView.toggleButtonEnabledState(false)
                topScoringCard.toggleButtonsEnabledState(true)
                bottomScoringCard.toggleButtonsEnabledState(true)
                rollButton.enabled = false
            }
            
            if gameLogic.rollsRemaining != 3 {
                topScoringCard.toggleButtonsEnabledState(true)
                bottomScoringCard.toggleButtonsEnabledState(true)
            }
        }
        else {
            diceView.toggleButtonEnabledState(false)
            topScoringCard.toggleButtonsEnabledState(false)
            bottomScoringCard.toggleButtonsEnabledState(false)
            rollButton.enabled = false
            nextTurnButton.enabled = true
        }

        navigationItem.title = "Player \(gameLogic.currentPlayer)"
        super.viewDidLoad()
    }
    
    func loadGame(previousGameLogic: YahtzeeGameLogic) {
        numPlayers = previousGameLogic.numPlayers
        gameLogic = previousGameLogic
    }
    
    func newGame(initialNumPlayers: Int) {
        numPlayers = initialNumPlayers
        gameLogic = YahtzeeGameLogic(playersThisGame: numPlayers)
    }
    
    // MARK: Roll button action
    @IBAction func rollButtonPressed(button: UIButton) {
        if gameLogic.rollsRemaining == 3 {
            try! gameLogic.rollDice([0, 1, 2, 3, 4])
            
            diceView.toggleButtonEnabledState(true)
            topScoringCard.toggleButtonsEnabledState(true)
            bottomScoringCard.toggleButtonsEnabledState(true)
            updateScoreCardsFromPotentialScores()
        }
        
        else if gameLogic.rollsRemaining != 0 {
            do {
                try gameLogic.rollDice([Int] (0..<5).filter({ diceView.buttonsSelected[$0] }))
                updateScoreCardsFromPotentialScores()
            }
            catch let error as YahtzeeLogicError {
                let alertCtl = UIAlertController(title: "Oops!", message: error.description, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertCtl.addAction(defaultAction)
                
                presentViewController(alertCtl, animated: true, completion: nil)
            } catch {
                print("unknown error: \(error)")
            }

            if gameLogic.rollsRemaining == 0 {
                diceView.toggleButtonEnabledState(false)
                button.enabled = false
            }
        }
        
        diceView.unselectAllDice()
        diceView.updateDiceImagesFromYahtzeeDiceAnimated(gameLogic.intDice)
    }
    
    // MARK: Score button action
    @IBAction func scoreButtonPressed(button: ScoreButton) {
        do {
            try gameLogic.scoreRoll(button.scoreType)
            button.solidifyScoreForRound()
            diceView.toggleButtonEnabledState(false)
            topScoringCard.toggleButtonsEnabledState(false)
            bottomScoringCard.toggleButtonsEnabledState(false)
            rollButton.enabled = false
            nextTurnButton.enabled = true
        }
        catch let error as YahtzeeLogicError {
            let alertCtl = UIAlertController(title: "Oops!", message: error.description, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertCtl.addAction(defaultAction)
            presentViewController(alertCtl, animated: true, completion: nil)
        }
        catch let error as ScoringCardError {
            let alertCtl = UIAlertController(title: "Oops!", message: String(error), preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertCtl.addAction(defaultAction)
            presentViewController(alertCtl, animated: true, completion: nil)
        }
        catch {
            print("go away, pesky error! begone!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! fienD!L!!!!!!!!!!")
        }
    }
    
    @inline(__always) func updateScoreCardsFromPotentialScores() {
        let alreadyScored = gameLogic.boxesAlreadyScoredForCurrentCard
        let scores = gameLogic.potentialScores
        topScoringCard.updateButtonTitlesFromNewScores(scores[0], previouslyScored: alreadyScored)
        bottomScoringCard.updateButtonTitlesFromNewScores(scores[1], previouslyScored: alreadyScored)
    }
    
    // MARK: Next turn action
    func newTurn() {
        // why did I create this?
        // because the order of these function calls matter
        // why?
        // i have no idea
        // this is just to make stuff nice and isolated. right? RIGHT?
        print("updating scoring cards from potential scores in newTurn:",
              "alreadyScored: \(gameLogic.boxesAlreadyScoredForCurrentCard)",
              "potentialScores: \(gameLogic.potentialScores)")
        
        topScoringCard.toggleButtonsEnabledState(false)
        bottomScoringCard.toggleButtonsEnabledState(false)
        
        let alreadyScored = gameLogic.boxesAlreadyScoredForCurrentCard
        let scores = gameLogic.potentialScores
        topScoringCard.updateButtonTitlesFromNewScores(scores[0], previouslyScored: alreadyScored)
        bottomScoringCard.updateButtonTitlesFromNewScores(scores[1], previouslyScored: alreadyScored)
    }
    
    @IBAction func nextTurnButtonPressed(button: UIBarButtonItem) {
        do {
            try gameLogic.nextTurn()
            navigationItem.title = "Player \(self.gameLogic.currentPlayer)"
            button.enabled = false
            rollButton.enabled = true
            diceView.toggleButtonEnabledState(false)
            newTurn()
        } catch let error as YahtzeeLogicError {
            if error == YahtzeeLogicError.GameOver {
                print("poop we haven't gotten this far yet")
            }
            else { print(error) }
        } catch {
            print("unknown error: \(error)")
        }
    }
}
