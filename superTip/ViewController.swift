//
//  ViewController.swift
//  superTip
//
//  Created by victor aguirre on 2/15/16.
//  Copyright © 2016 victor aguirre. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DataEnteredDelegate {
    
    //Load persistence
    let defaults = NSUserDefaults.standardUserDefaults()
    
    //views in view Bill Amount
    @IBOutlet weak var viewBillAmout: UIView!
    @IBOutlet weak var labelBillAmount: UILabel!
    @IBOutlet weak var textFieldBillAmount: UITextField!
    
    //Views in view Service quality view
    @IBOutlet weak var viewService: UIView!
    @IBOutlet weak var buttonBad: UIButton!
    @IBOutlet weak var buttonGood: UIButton!
    @IBOutlet weak var buttonExcellent: UIButton!
    @IBOutlet weak var viewSplitServiceRight: UIView!
    @IBOutlet weak var viewSplitServiceLeft: UIView!
    
    //views in tip view
    @IBOutlet weak var viewTip: UIView!
    @IBOutlet weak var labelTipPorcentageTitle: UILabel!
    @IBOutlet weak var labelTipPorcentage: UILabel!
    @IBOutlet weak var labelTipTotalTitle: UILabel!
    @IBOutlet weak var labelTipTotal: UILabel!
    
    @IBOutlet weak var stepperNumberPeople: UIStepper!
    @IBOutlet weak var labelNumberPeopleTitle: UILabel!
    @IBOutlet weak var labelNumberPeople: UILabel!
    
    @IBOutlet weak var viewSplitTip1: UIView!
    @IBOutlet weak var viewSplitTip2: UIView!
    
    //views in total bill view
    @IBOutlet weak var viewTotalBill: UIView!
    @IBOutlet weak var labelTotalBill: UILabel!
    @IBOutlet weak var labelTotalBillTitle: UILabel!
    
    var tipPorcentages: [Double] = [18,20,22]
    var tip: Double = Double()
    var total: Double = Double()
    var tipPorcentage:Double = Double()
    var billAmount:Double = Double()
    
    var previousDate: [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewService.alpha = 0
        viewTip.alpha = 0
        viewTotalBill.alpha = 0
        viewSplitServiceLeft.alpha = 0
        viewSplitServiceRight.alpha = 0
        viewSplitTip1.alpha = 0
        viewSplitTip1.alpha = 0
        textFieldBillAmount.becomeFirstResponder()
        
        //get the current date
        var newDate:[Int] = getDate()
        //recover the last date where the bill was calculated
        var previousDate: [Int] = [defaults.integerForKey("hour"),defaults.integerForKey("minute")]
        
        //check if the las bill was < 10 minutes
        if newDate[0] == previousDate[0]{
            if newDate[1] - previousDate[1]  < 10 {
                self.viewService.alpha = 1
                self.viewSplitServiceLeft.alpha = 1
                self.viewSplitServiceRight.alpha = 1
                self.viewTip.alpha = 1
                self.viewTotalBill.alpha = 1
                self.viewSplitTip1.alpha = 1
                self.viewSplitTip1.alpha = 1
                textFieldBillAmount.text = String(defaults.valueForKey("bill")!)
                billAmount = defaults.doubleForKey("bill")
                stepperNumberPeople.value = defaults.doubleForKey("numberPerson")
                calculate(billAmount, tipPorcentage: tipPorcentages[0], numberPeople: stepperNumberPeople.value)
                display(tipPorcentages[0], totalBill: total, numberPeope: stepperNumberPeople.value)
           }
        }
    }

    @IBAction func onEditBillAmount(sender: AnyObject) {
        UIView.animateWithDuration(0.5, animations: {
            self.viewService.alpha = 1
            self.viewSplitServiceLeft.alpha = 1
            self.viewSplitServiceRight.alpha = 1
        })
        
        //if the bill amount is modify
        if viewTotalBill.alpha == 1{
            billAmount = NSString(string: textFieldBillAmount.text!).doubleValue
            calculate(billAmount, tipPorcentage: tipPorcentage, numberPeople: stepperNumberPeople.value)
            display(tipPorcentage, totalBill: total, numberPeope: stepperNumberPeople.value)
        }
    }
    
    @IBAction func onPushServiceRate(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: {
            self.viewTip.alpha = 1
            self.viewTotalBill.alpha = 1
            self.viewSplitTip1.alpha = 1
            self.viewSplitTip1.alpha = 1
        })
        billAmount = NSString(string: textFieldBillAmount.text!).doubleValue
    }
    
    @IBAction func onButtonBadPushed(sender: AnyObject) {
        tipPorcentage = tipPorcentages[0]
        billAmount = NSString(string: textFieldBillAmount.text!).doubleValue
        calculate(billAmount, tipPorcentage: tipPorcentage, numberPeople: stepperNumberPeople.value)
        display(tipPorcentage, totalBill: total, numberPeope: stepperNumberPeople.value)
    }
    
    @IBAction func onButtonGoodPushed(sender: AnyObject) {
        tipPorcentage = tipPorcentages[1]
        billAmount = NSString(string: textFieldBillAmount.text!).doubleValue
        calculate(billAmount, tipPorcentage: tipPorcentage, numberPeople: stepperNumberPeople.value)
        display(tipPorcentage, totalBill: total, numberPeope: stepperNumberPeople.value)
    }
    
    @IBAction func onButtonExcellentPuched(sender: AnyObject) {
        tipPorcentage = tipPorcentages[2]
        billAmount = NSString(string: textFieldBillAmount.text!).doubleValue
        calculate(billAmount, tipPorcentage: tipPorcentage, numberPeople: stepperNumberPeople.value)
        display(tipPorcentage, totalBill: total, numberPeope: stepperNumberPeople.value)
    }
    
    @IBAction func onTapStepper(sender: AnyObject) {
        calculate(billAmount, tipPorcentage: tipPorcentage, numberPeople: stepperNumberPeople.value)
        display(tipPorcentage, totalBill: total, numberPeope: stepperNumberPeople.value)
    }
    
    func display(tipPorcentage:Double,totalBill:Double,numberPeope:Double){
        labelTipPorcentage.text = String(format: "%.0f",tipPorcentage) + "%"
        labelTipTotal.text = String(format: "$%.2f", tip)
        labelTotalBill.text = String(format: "$%.2f", total)
        labelNumberPeople.text = String(format: "%.0f",stepperNumberPeople.value)
        
        if stepperNumberPeople.value > 1 {
            UIView.animateWithDuration(0.4, animations: {
                self.labelTotalBillTitle.text = "Total per Person"
            })
        }
        
        previousDate = getDate()
        defaults.setInteger(previousDate[0], forKey: "hour")
        defaults.setInteger(previousDate[1], forKey: "minute")
        defaults.setDouble(Double(textFieldBillAmount.text!)!, forKey: "bill")
        defaults.setDouble(stepperNumberPeople.value, forKey: "numberPerson")
    }
    
    func calculate(billAmout: Double, tipPorcentage:Double,numberPeople:Double){
        onTap(self)
        tip = (tipPorcentage / 100) * billAmout
        total = (billAmout + tip) / numberPeople
    }
    
    func getDate() -> [Int] {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date)
        let hour = components.hour % 12
        let minute = components.minute
        let second = components.second
        let nanosecond = components.nanosecond
        return [Int(hour),Int(minute),Int(second),Int(nanosecond)]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "changePorcentages"{
            let secondVC:SettingsViewController = segue.destinationViewController as! SettingsViewController
            secondVC.delegate = self
        }
    }
    
    func userDidEnterInformation(porcentages: [Double], isSaved: Bool){
        billAmount = NSString(string: textFieldBillAmount.text!).doubleValue
        display(tipPorcentages[0], totalBill: total, numberPeope: stepperNumberPeople.value)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaults.boolForKey("isSaved") {
            tipPorcentages = [defaults.doubleForKey("Bad"), defaults.doubleForKey("Good"), defaults.doubleForKey("Excellent")]
            
            if viewTip.alpha == 1{
                textFieldBillAmount.text = String(defaults.valueForKey("bill")!)
                billAmount = defaults.doubleForKey("bill")
                tipPorcentage = tipPorcentages[0]
                stepperNumberPeople.value = defaults.doubleForKey("numberPerson")
                labelNumberPeople.text = String(stepperNumberPeople.value)
                onTapStepper(self)
            }
            
        }
    }
}