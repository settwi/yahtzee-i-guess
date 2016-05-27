//
//  ViewController.swift
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if numPlayers != 0 {
            print("numPlayers: \(numPlayers)")
            performSegueWithIdentifier("GameSegue", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMainWindow(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? NewGameViewController {
            numPlayers = sourceViewController.numPlayers
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? GameViewController {
            destination.numPlayers = numPlayers
        } else {
            print("WFHWEFWLEFJLWEJFLKWLEKFJ")
        }
    }
}

