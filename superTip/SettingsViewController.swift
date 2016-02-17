//
//  SettingsViewController.swift
//  superTip
//
//  Created by victor aguirre on 2/15/16.
//  Copyright © 2016 victor aguirre. All rights reserved.
//

import UIKit

protocol DataEnteredDelegate{
    func userDidEnterInformation(porcentage: [Double], isSaved: Bool)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var sliderBad: UISlider!
    @IBOutlet weak var labelBad: UILabel!
    @IBOutlet weak var sliderGood: UISlider!
    @IBOutlet weak var labelGood: UILabel!
    @IBOutlet weak var labelExcellent: UILabel!
    @IBOutlet weak var sliderExcellent: UISlider!
    
    var porcentages = [18,20,22]
    var newPorcentages:[Double] = [Double]()
    var isSaved: Bool = Bool()
    
    var delegate:DataEnteredDelegate? = nil
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.boolForKey("isSaved"){
            porcentages = [Int(defaults.doubleForKey("Bad")), Int(defaults.doubleForKey("Good")), Int(defaults.doubleForKey("Excellent"))]
            labelBad.text = String(porcentages[0]) + "%"
            print(labelBad.text)
            sliderBad.value = Float(porcentages[0])
            print(sliderBad.value)
            labelGood.text = String(porcentages[1]) + "%"
            print(labelBad.text)
            sliderGood.value = Float(porcentages[1])
            print(sliderGood.value)
            labelExcellent.text = String(porcentages[2]) + "%"
            print(labelExcellent.text)
            sliderExcellent.value = Float(porcentages[2])
            print(sliderExcellent.value)

        } else {
            porcentages = [18,20,22]
            labelBad.text = String(porcentages[0]) + "%"
            print(labelBad.text)
            sliderBad.value = Float(porcentages[0])
            print(sliderBad.value)
            labelGood.text = String(porcentages[1]) + "%"
            print(labelBad.text)
            sliderGood.value = Float(porcentages[1])
            print(sliderGood.value)
            labelExcellent.text = String(porcentages[2]) + "%"
            print(labelExcellent.text)
            sliderExcellent.value = Float(porcentages[2])
            print(sliderExcellent.value)
        }

    }

    @IBAction func onResetSettings(sender: AnyObject) {
        porcentages = [18,20,22]
        labelBad.text = String(porcentages[0]) + "%"
        print(labelBad.text)
        sliderBad.value = Float(porcentages[0])
        print(sliderBad.value)
        labelGood.text = String(porcentages[1]) + "%"
        print(labelBad.text)
        sliderGood.value = Float(porcentages[1])
        print(sliderGood.value)
        labelExcellent.text = String(porcentages[2]) + "%"
        print(labelExcellent.text)
        sliderExcellent.value = Float(porcentages[2])
        print(sliderExcellent.value)
        if defaults.boolForKey("isSaved"){
            isSaved = false
            defaults.setBool(isSaved, forKey: "isSaved")
        }
    }
    @IBAction func onSliderBadChanged(sender: AnyObject) {
        labelBad.text = String(format: "%.0f", sliderBad.value) + "%"
       // newPorcentages[0] = Double(Int(sliderBad.value))
            //NSString(string: labelBad.text!).doubleValue
    }
    @IBAction func onSliderGoodChanged(sender: AnyObject) {
        labelGood.text = String(format: "%.0f", sliderGood.value) + "%"
        //newPorcentages[1] = Double(Int(sliderGood.value))
    }
    @IBAction func OnSliderExcellentChanged(sender: AnyObject) {
        labelExcellent.text = String(format: "%.0f", sliderExcellent.value) + "%"
        //newPorcentages[2] = Double(Int(sliderExcellent.value))
    }
    @IBAction func onSaveSettings(sender: AnyObject) {
        newPorcentages = [Double(Int(sliderBad.value)),Double(Int(sliderGood.value)),Double(Int(sliderExcellent.value))]
        isSaved = true
        defaults.setDouble(newPorcentages[0], forKey: "Bad")
        defaults.setDouble(newPorcentages[1], forKey: "Good")
        defaults.setDouble(newPorcentages[2], forKey: "Excellent")
        defaults.setBool(isSaved, forKey: "isSaved")
        defaults.synchronize()
        
        if delegate != nil{
            delegate!.userDidEnterInformation(newPorcentages,isSaved: isSaved)
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        if defaults.boolForKey("isSaved"){
            porcentages = [Int(defaults.doubleForKey("Bad")), Int(defaults.doubleForKey("Good")), Int(defaults.doubleForKey("Excellent"))]
            labelBad.text = String(porcentages[0]) + "%"
            sliderBad.value = Float(porcentages[0])
            labelGood.text = String(porcentages[1]) + "%"
            sliderGood.value = Float(porcentages[1])
            labelExcellent.text = String(porcentages[2]) + "%"
            sliderExcellent.value = Float(porcentages[2])
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        newPorcentages = [Double(Int(sliderBad.value)),Double(Int(sliderGood.value)),Double(Int(sliderExcellent.value))]
        labelBad.text = String(porcentages[0]) + "%"
        sliderBad.value = Float(porcentages[0])
        labelGood.text = String(porcentages[1]) + "%"
        sliderGood.value = Float(porcentages[1])
        labelExcellent.text = String(porcentages[2]) + "%"
        sliderExcellent.value = Float(porcentages[2])
        
        if !defaults.boolForKey("isSaved"){
            isSaved = true
            defaults.setDouble(newPorcentages[0], forKey: "Bad")
            defaults.setDouble(newPorcentages[1], forKey: "Good")
            defaults.setDouble(newPorcentages[2], forKey: "Excellent")
            defaults.setBool(isSaved, forKey: "isSaved")
            defaults.synchronize()
        }
    }
}
