//
//  ScoringButtonsViewController.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 6/1/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class ScoringButtonsViewController: UIViewController {

    // MARK: Properties
    var containingStackView: UIStackView!
    var firstSectionStackView: UIStackView!
    var secondSectionStackView: UIStackView!
    var firstButtons = [UIButton]()
    var secondButtons = [UIButton]()
    
    let firstButtonNames = [
        "Ones", "Twos", "Threes", "Fours",
        "Fives", "Sixes", "Roll"
    ]
    let secondButtonNames = [
        "Three of A Kind", "Four of A Kind", "Full House",
        "Small Straight", "Large Straight", "Yahtzee",
        "Chance"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createScorecard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createScorecard() {
        var tag = 0
        // go from in to out
        firstButtons = firstButtonNames.map({ (name: String) in
            let button = UIButton(type: .System)
            button.setTitle(name, forState: .Normal)
            button.tag = tag
            tag += 1
            return button
        })
        
        secondButtons = secondButtonNames.map({ (name: String) in
            let button = UIButton(type: .System)
            button.setTitle(name, forState: .Normal)
            button.tag = tag
            tag += 1
            return button
        })
        
        firstSectionStackView = UIStackView(arrangedSubviews: firstButtons)
        secondSectionStackView = UIStackView(arrangedSubviews: secondButtons)
        let innerStackViews = [firstSectionStackView, secondSectionStackView]
        for view in innerStackViews {
            view.spacing = 3
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .Vertical
            view.alignment = .Fill
            view.distribution = .Fill
        }
        
        let convertedViews = innerStackViews.map { $0 as UIView }
        print(convertedViews.count) // indoctrinated to the fullest
        containingStackView = UIStackView(arrangedSubviews: innerStackViews.map { $0 as UIView })
        containingStackView.axis = .Horizontal
        containingStackView.alignment = .Center
        containingStackView.distribution = .FillEqually
        view.addSubview(containingStackView)

        // here we go
        let viewsDictionary = ["containingStackView": containingStackView]
        let stackView_H = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[containingStackView]-0-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[containingStackView]-0-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        view.addConstraints(stackView_H)
        view.addConstraints(stackView_V)
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
