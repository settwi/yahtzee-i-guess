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
    @IBOutlet weak var rollButton: UIBarButtonItem!
    @IBOutlet weak var diceView: SelectDiceView!
    var gameLogic: YahtzeeGameLogic!             // implicitly unwrapped to avoid initializer loll
    var numPlayers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diceView.updateDiceImagesFromYahtzeeDice(gameLogic.intDice)
        if gameLogic.rollsRemaining == 3 {
            diceView.toggleButtonEnabledState(false)
        }
        else if gameLogic.rollsRemaining == 0 {
            diceView.toggleButtonEnabledState(false)
            rollButton.enabled = false
        }
    }
    
    func loadGame(previousGameLogic: YahtzeeGameLogic) {
        numPlayers = previousGameLogic.numPlayers
        gameLogic = previousGameLogic
    }
    
    func newGame(initialNumPlayers: Int) {
        numPlayers = initialNumPlayers
        gameLogic = YahtzeeGameLogic(playersThisGame: numPlayers)
        // this is like a fake initializer so might as well take advantage of it
    }
    
    // MARK: Roll button action
    @IBAction func rollButtonPressed(button: UIBarButtonItem) {
        if gameLogic.rollsRemaining == 3 {
            try! gameLogic.rollDice([0, 1, 2, 3, 4])
            diceView.toggleButtonEnabledState(true)
        }
        
        else if gameLogic.rollsRemaining != 0 {
            do {
                try gameLogic.rollDice([Int](0..<5).filter({ diceView.buttonsSelected[$0] }))
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
        // to be continued
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // nothing yet. save function?
    }
}
