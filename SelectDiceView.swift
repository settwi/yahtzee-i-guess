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
    var buttonsTapped = [Bool]()    // highlights buttons tapped. i guess
    let numDice = 5
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buttonsTapped = [false, false, false, false, false]
        defaultDiceImages = (1...numDice).map({ (i: Int) in UIImage(named: String(i))! })
        selectedDiceImages = (1...numDice).map({ (i: Int) in UIImage(named: "\(i)_selected")! })
        
        for i in 0..<numDice {
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
        let buttonSize = Int(frame.size.width) / numDice
        print(buttonSize)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        for (i, button) in diceButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(i * buttonSize)
            button.frame = buttonFrame
        }

        updateDiceSelectedStates()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.width) / numDice
        let width = Int(frame.size.width)
        return CGSize(width: width, height: buttonSize)
    }
    
    // MARK: Button Action
    func dieTapped(button: UIButton) {
        let buttonIndex = diceButtons.indexOf(button)!
        print("Pressed die \(buttonIndex)")
        
        buttonsTapped[buttonIndex] = !buttonsTapped[buttonIndex]
        
        updateDiceSelectedStates()
    }
    
    func updateDiceSelectedStates() {
        for (i, tapped) in buttonsTapped.enumerate() {
            diceButtons[i].selected = tapped
        }
    }
    
    // MARK: Data transfer
    func updateDiceImagesFromYahtzeeDice(newDice: [Int]) {
        for i in newDice.map({ $0 - 1 }) {
            diceButtons[i].setImage(defaultDiceImages[i],
                                    forState: [.Normal, .Disabled])
            diceButtons[i].setImage(selectedDiceImages[i], forState: .Selected)
        }
    }
}
