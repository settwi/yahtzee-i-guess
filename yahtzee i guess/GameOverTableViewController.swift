//
//  GameOverTableViewController.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 6/3/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class GameOverTableViewController: UITableViewController {

    var scoreCards: [YahtzeeScoringCard]!
    var maxScoreIndex: Int = 0
    
    override func viewDidLoad() {
        var maxCard = scoreCards[0]
        var maxScore = maxCard.totalScore().reduce(0, combine: +)
        for card in scoreCards {
            let currentScore = card.totalScore().reduce(0, combine: +)
            if maxScore < currentScore {
                maxScore = currentScore
                maxCard = card
            }
        }
        maxScoreIndex = scoreCards.indexOf(maxCard)!
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreCards.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "GameOverCellID", forIndexPath: indexPath) as! GameOverTableViewCell
        let scores = scoreCards[indexPath.row].totalScore()
        let topScore = scores[0]
        let topBonus = scores[1]
        let bottomScore = scores[2]
        let yahtzeeBonus = scores[3]
        
        cell.playerLabel.text = "Player \(indexPath.row + 1)"
        cell.topScoreLabel.text = "Top Score - \(topScore)"
        cell.bottomScoreLabel.text = "Bottom Score - \(bottomScore)"
        cell.topBonusLabel.text = "Top Bonus - \(topBonus)"
        cell.yahtzeeBonusLabel.text = "Yahtzee Bonus - \(yahtzeeBonus)"
        cell.grandTotalLabel.text = "Grand Total - \(scores.reduce(0, combine: +))"
        
        if maxScoreIndex == indexPath.row {
            cell.playerLabel.textColor = UIColor.blueColor()
            cell.topScoreLabel.textColor = UIColor.blueColor()
            cell.bottomScoreLabel.textColor = UIColor.blueColor()
            cell.topBonusLabel.textColor = UIColor.blueColor()
            cell.yahtzeeBonusLabel.textColor = UIColor.blueColor()
            cell.grandTotalLabel.textColor = UIColor.blueColor()
        }
        
        return cell
    }
}
