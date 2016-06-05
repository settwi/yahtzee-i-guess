//
//  SelectDiceView.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 5/28/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class SelectDiceView: UIView {
    // MARK: Properties
    var diceButtons = [UIButton]()
    var defaultDiceImages = [UIImage]()
    var selectedDiceImages = [UIImage]()
    var buttonsSelected = [Bool]()    // highlights buttons tapped. i guess
    let numDice = 6
    let numDiceDisplayed = 5
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buttonsSelected = [false, false, false, false, false]
        defaultDiceImages = (1...numDice).map({ (i: Int) in UIImage(named: String(i))! })
        selectedDiceImages = (1...numDice).map({ (i: Int) in UIImage(named: "\(i)_selected")! })
        
        for i in 0..<numDiceDisplayed {
            let button = UIButton()
            button.setImage(defaultDiceImages[i], forState: .Normal)
            button.setImage(defaultDiceImages[i], forState: .Disabled)
            button.setImage(selectedDiceImages[i], forState: .Selected)
            button.addTarget(self, action: #selector(SelectDiceView.dieTapped(_:)),
                             forControlEvents: .TouchDown)
            
            button.contentMode = .ScaleToFill
            button.contentHorizontalAlignment = .Fill
            button.contentVerticalAlignment = .Fill
            diceButtons.append(button)
            addSubview(button)
        }
    }

    override func layoutSubviews() {
        let buttonSize = Int(frame.size.height)
        // kinda temporary thing so yep deal with it
        let xOffset = (Int(frame.size.width) - buttonSize * 5) / 2
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        for (i, button) in diceButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(i * buttonSize) + CGFloat(xOffset)
            button.frame = buttonFrame
        }

        updateDiceSelectedStates()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = Int(frame.size.width) * numDiceDisplayed
        return CGSize(width: width, height: buttonSize)
    }
 
    // MARK: Button Action
    func toggleButtonEnabledState(enabled: Bool) {
        unselectAllDice()
        for button in diceButtons {
            button.alpha = enabled ? CGFloat(1) : CGFloat(0.4)
            button.enabled = enabled
        }
    }
    
    func dieTapped(button: UIButton) {
        let buttonIndex = diceButtons.indexOf(button)!
        buttonsSelected[buttonIndex] = !buttonsSelected[buttonIndex]
        
        updateDiceSelectedStates()
    }
    
    func unselectAllDice() {
        buttonsSelected = [false, false, false, false, false]
        updateDiceSelectedStates()
    }
    
    func updateDiceSelectedStates() {
        for (i, tapped) in buttonsSelected.enumerate() {
            diceButtons[i].selected = tapped
        }
    }
    
    // MARK: Data transfer
    func updateDiceImagesFromYahtzeeDice(newDice: [Int]) {
        // assumes newDice.count == 5
        for (buttonIndex, imgIndex) in newDice.map({ $0 - 1 }).enumerate() {
            diceButtons[buttonIndex].setImage(defaultDiceImages[imgIndex], forState: .Normal)
            diceButtons[buttonIndex].setImage(defaultDiceImages[imgIndex], forState: .Disabled)
            diceButtons[buttonIndex].setImage(selectedDiceImages[imgIndex], forState: .Selected)
        }
        
        updateDiceSelectedStates()
    }
    
    func updateDiceImagesFromYahtzeeDiceAnimated(newDice: [Int]) {
        // if we have time, have something like this use an NSTimer to randomize some dice
        /*
        for _ in 0..<5 {
            for buttonIndex in 0..<5 {
                let imgIndex = Int(arc4random() % 6)
                diceButtons[buttonIndex].setImage(defaultDiceImages[imgIndex], forState: .Normal)
                diceButtons[buttonIndex].setImage(defaultDiceImages[imgIndex], forState: .Disabled)
                diceButtons[buttonIndex].setImage(selectedDiceImages[imgIndex], forState: .Selected)
            }
        }
        */
        
        updateDiceImagesFromYahtzeeDice(newDice)
    }
}
