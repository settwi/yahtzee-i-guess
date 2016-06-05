//
//  InitialScreenViewController.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 5/20/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class InitialScreenViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var continueGameButton: UIButton!
    var numPlayers: Int = 0
    var previousGameLogic: YahtzeeGameLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let gameLogic = loadPreviousGame() {
            previousGameLogic = gameLogic
            continueGameButton.enabled = true
        } else {
            continueGameButton.enabled = false
        }
        
        if numPlayers != 0 {
            performSegueWithIdentifier("GameSegue", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMainScreen(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? NewGameViewController {
            numPlayers = sourceViewController.numPlayers
        }
        else if let sourceViewController = sender.sourceViewController as? GameViewController {
            saveGame(sourceViewController.gameLogic)
            numPlayers = 0 // this is so the game thing doesn't pop up again...
        }
        else if sender.sourceViewController is GameOverTableViewController {
            deleteGameAfterFinishes()
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navDestination = segue.destinationViewController as? UINavigationController,
           let destination = navDestination.topViewController as? GameViewController {
            if numPlayers != 0 {
                let localNumPlayers = numPlayers
                numPlayers = 0 // so that it doesn't flip flop when unloading game view
                destination.newGame(localNumPlayers)
            } else {
                destination.loadGame(previousGameLogic!)
            }
        }
    }
    
    // MARK: NSCoding
    func loadPreviousGame() -> YahtzeeGameLogic? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(
            YahtzeeGameLogic.ArchiveURL.path!) as? YahtzeeGameLogic
    }
    
    func saveGame(gameLogic: YahtzeeGameLogic) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(gameLogic, toFile: YahtzeeGameLogic.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("save failed.")
        }
    }
    
    func deleteGameAfterFinishes() {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(YahtzeeGameLogic.ArchiveURL.path!) {
            do { try fileManager.removeItemAtPath(YahtzeeGameLogic.ArchiveURL.path!) }
            catch { print("error removing saved gameLogic: \(error)") }
        }
    }
}
