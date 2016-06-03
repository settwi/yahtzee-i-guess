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
        updateTotalScoresOnScoreCards()

        if !gameLogic.scoredThisTurn {
            if gameLogic.rollsRemaining == 3 {
                diceView.toggleButtonEnabledState(false)
                updateAndToggleScorecards(false)
            }
            else if gameLogic.rollsRemaining == 0 {
                diceView.toggleButtonEnabledState(false)
                updateAndToggleScorecards(true)
                rollButton.enabled = false
            }
            
            if gameLogic.rollsRemaining != 3 {
                updateAndToggleScorecards(true)
            }
        }
        else {
            diceView.toggleButtonEnabledState(false)
            updateAndToggleScorecards(false)
            rollButton.enabled = false
            nextTurnButton.enabled = true
        }
        
        updateTotalScoresOnScoreCards()
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
    
    func updateTotalScoresOnScoreCards() {
        let currentTotalScore = gameLogic.currentTotalScore
        let topScore = currentTotalScore[0]
        let topBonus = currentTotalScore[1]
        let bottomScore = currentTotalScore[2]
        let yahtzeeBonus =  currentTotalScore[3]
        
        topScoringCard.updateScoreBoxes(topScore + topBonus, grandTotal: currentTotalScore.reduce(0, combine: +))
        bottomScoringCard.updateScoreBoxes(bottomScore + yahtzeeBonus)
    }
    
    // MARK: Roll button action
    @IBAction func rollButtonPressed(button: UIButton) {
        // shoutout to tait for the great idea of 
        // a shaking rolling thingy
        if gameLogic.rollsRemaining == 3 {
            try! gameLogic.rollDice([0, 1, 2, 3, 4])
            
            diceView.toggleButtonEnabledState(true)
            updateAndToggleScorecards(true)
        }
        
        else if gameLogic.rollsRemaining != 0 {
            do {
                try gameLogic.rollDice([Int] (0..<5).filter({ !diceView.buttonsSelected[$0] }))
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
        
        //Hey buddy pal, I hope you're having a great day
    }
    
    @IBAction func scoreButtonPressed(button: ScoreButton) {
        let key = button.scoreType
        var scoreVal = 0
        if gameLogic.potentialScores[0].keys.contains(key) {
            scoreVal = gameLogic.potentialScores[0][key]!
        }
        else if gameLogic.potentialScores[1].keys.contains(key) {
             scoreVal = gameLogic.potentialScores[1][key]!
        }

        let alertCtl = UIAlertController(title: "Score?",
            message: "Would you like to score \(button.scoreType) for \(scoreVal) points?", preferredStyle: .Alert)
        let yesButton = UIAlertAction(title: "Yes", style: .Default, handler: { (_: UIAlertAction) in
            self.userWantsToScore(button)
        })
        let noButton = UIAlertAction(title: "No", style: .Default, handler: nil)
        alertCtl.addAction(yesButton)
        alertCtl.addAction(noButton)
    
        presentViewController(alertCtl, animated: true, completion: nil)
    }
    
    // MARK: Score button action
    func userWantsToScore(button: ScoreButton) {
        do {
            try gameLogic.scoreRoll(button.scoreType)
            button.solidifyScoreForRound()
            updateTotalScoresOnScoreCards()
            diceView.toggleButtonEnabledState(false)
            updateAndToggleScorecards(false)
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
    
    func updateScoreCardsFromPotentialScores() {
        let alreadyScored = gameLogic.boxesAlreadyScoredForCurrentCard
        let scores = gameLogic.potentialScores
        topScoringCard.updateButtonTitlesFromNewScores(scores[0], previouslyScored: alreadyScored)
        bottomScoringCard.updateButtonTitlesFromNewScores(scores[1], previouslyScored: alreadyScored)
    }
    
    // MARK: Next turn action
    func updateAndToggleScorecards(enabled: Bool) {
        // why did I create this?
        // because the order of these function calls matter
        // why?
        // i have no idea
        // this is just to make stuff nice and abstracted and isolated. right? RIGHT?
        updateScoreCardsFromPotentialScores()
        topScoringCard.toggleButtonsEnabledState(enabled)
        bottomScoringCard.toggleButtonsEnabledState(enabled)
    }
    
    @IBAction func nextTurnButtonPressed(button: UIBarButtonItem) {
        do {
            try gameLogic.nextTurn()
            navigationItem.title = "Player \(self.gameLogic.currentPlayer)"
            updateTotalScoresOnScoreCards()
            button.enabled = false
            rollButton.enabled = true
            diceView.toggleButtonEnabledState(false)
            updateAndToggleScorecards(false)
        } catch let error as YahtzeeLogicError {
            if error == YahtzeeLogicError.GameOver {
                handleGameOver()
            }
            else { print(error) }
        } catch {
            print("unknown error: \(error)")
        }
    }
    
    func handleGameOver() {
        performSegueWithIdentifier("GameOverSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GameOverSegue" {
            if let destinationNav = segue.destinationViewController as? UINavigationController {
                if let gameOverTableView = destinationNav.topViewController as? GameOverTableViewController {
                    gameOverTableView.scoreCards = gameLogic.scoreCards
                }
            }
        }
    }
}
