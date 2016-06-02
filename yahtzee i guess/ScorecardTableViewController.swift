//
//  ScorecardTableViewController.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 5/30/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class ScorecardTableViewController: UITableViewController {
    let cellTitles = [
        "Top",
        "",
        "Ones",
        "Twos",
        "Threes",
        "Fours",
        "Fives",
        "Sixes",
        "Bonus",
        "Total",
        "",
        "3 of A Kind",
        "4 of A Kind",
        "Full House",
        "Small Straight",
        "Large Straight",
        "YAHTZEE",
        "Chance",
        "Yahtzee Bonus",
        "Bottom Total",
        "",
        "Grand Total"
    ]
    var currentPotentialScores: [[String: Int]]? {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "ScoreCell", forIndexPath: indexPath) as! ScorecardTableViewCell
        
        let scoreTitle = cellTitles[indexPath.row]
        cell.scoreTypeLabel.text = scoreTitle
        if let potentialScores = currentPotentialScores {
            if let score = potentialScores[0][scoreTitle] {
                cell.scoreLabel.text = String(score)
                cell.scoreLabel.textColor = UIColor.redColor()
            }
            else if let score = potentialScores[1][scoreTitle] {
                cell.scoreLabel.text = String(score)
                cell.scoreLabel.textColor = UIColor.redColor()
            }
            else {
                cell.scoreLabel.text = ""
                cell.scoreLabel.textColor = UIColor.blackColor()
            }
        } else {
            cell.scoreLabel.text = ""
        }
        
        return cell
    }
    
    // MARK: Scoring cell updating
    func toggleScoringCellsEnabled(enabled: Bool) {
        // ok cool do later
    }
    
    func updateScoringCellsFromPotentialScores(scores: [[String: Int]]) {
        currentPotentialScores = scores
        let currentCells = tableView.visibleCells
        for (i, cellTitle) in cellTitles.enumerate() {
            if !currentCells.indices.contains(i) { break }
            
            let scoreVal = scores[0][cellTitle] ?? scores[1][cellTitle]
            let currentCell = currentCells[i] as! ScorecardTableViewCell
            
            if let unwrappedScoreVal = scoreVal {
                currentCell.scoreLabel.text = String(unwrappedScoreVal)
            }
            else {
                currentCell.scoreLabel.text = ""
            }
            currentCell.scoreLabel.textColor = UIColor.redColor()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
