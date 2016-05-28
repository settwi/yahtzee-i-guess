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
    @IBOutlet weak var testlabel: UILabel!
    var numPlayers: Int = 0
    var gameLogic: YahtzeeGameLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testlabel.text = String(numPlayers)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func receiveDataFromMainView(initialNumPlayers: Int?, previousGameLogic: YahtzeeGameLogic?) {
        // default each to one player
        numPlayers = initialNumPlayers ?? previousGameLogic?.numPlayers ?? 1
        gameLogic = previousGameLogic ?? YahtzeeGameLogic(playersThisGame: self.numPlayers)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // nothing yet. save function?
    }
}
