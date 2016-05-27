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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testlabel.text = String(numPlayers)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let sourceViewController = segue.sourceViewController as? InitialScreenViewController {
            numPlayers = sourceViewController.numPlayers
            print("ok game view controller we hsould have stuff assigned right now oo")
        } else {
            print("WFHWEFWLEFJLWEJFLKWLEKFJ")
        }
    }
}
