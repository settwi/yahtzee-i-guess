//
//  NewGameViewController.swift
//  yahtzee i guess
//
//  Created by William Setterberg on 5/27/16.
//  Copyright © 2016 Joselliam. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController,
    UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: Properties
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var playerPicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    var numPlayers: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerPicker.delegate = self
        playerPicker.dataSource = self
        
        numPlayers = 1 // default
        pickerData = (1...6).map({ String($0) })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: UIPickerViewDelegate
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numPlayers = Int(pickerData[row]) ?? 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // MARK: - Navigation
    @IBAction func exit(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    

}
