//
//  AddChangeViewController.swift
//  CoreDataLearning
//
//  Created by Pawel Furtek on 7/23/16.
//  Copyright © 2016 Pawel Furtek. All rights reserved.
//

import UIKit
import Eureka
import MagicalRecord

class AddChangeViewController: FormViewController {
    
    var name: String = ""
    var color: String = "#FFFFFF"
    var number: NSNumber?
    var date: NSDate?
    var edit = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let oldColor = UIColor(hex: color, alpha: 1.0)

        // Do any additional setup after loading the view.
        
        form =
            
            Section("General Information")
            <<< TextFloatLabelRow("Name") { row in
                row.title = "Enter your name:"
                row.value = self.name
                row.cell.textField.autocapitalizationType = UITextAutocapitalizationType.Words
            }
            
            <<< IntFloatLabelRow("Number") { row in
                row.title = "Enter your lucky number:"
                if let number = self.number {
                    row.value = number.integerValue
                }
            }
            <<< DateRow("Birthday") { row in
                row.value = self.date
                row.title = "Birthday:"
            }
            +++ Section("Favorite color")
            <<< LabelRow("Color") { row in
                row.title = "Your favorite color:"
                row.value = color
                row.cell.backgroundColor = oldColor
            }.onCellSelection({ (cell, row) in
                let redRow = self.form.rowByTag("Red") as! SliderRow
                let greenRow = self.form.rowByTag("Green") as! SliderRow
                let blueRow = self.form.rowByTag("Blue") as! SliderRow
                redRow.hidden = (redRow.isHidden ? false : true)
                greenRow.hidden = (greenRow.isHidden ? false : true)
                blueRow.hidden = (blueRow.isHidden ? false : true)
                redRow.evaluateHidden()
                greenRow.evaluateHidden()
                blueRow.evaluateHidden()
            })
            <<< SliderRow("Red") { row in
                row.title = "Amount of red:"
                row.value = Float(CGColorGetComponents(oldColor.CGColor)[0])*255
                row.minimumValue = 0
                row.maximumValue = 255
                row.steps = 255
                //row.cell.backgroundColor = oldColor
                row.hidden = true
            }.onChange({ (row) in
                let newColor = UIColor(colorLiteralRed: row.value!/255, green: (self.form.rowByTag("Green") as! SliderRow).value!/255, blue: (self.form.rowByTag("Blue") as! SliderRow).value!/255, alpha: 1.0)
                (self.form.rowByTag("Color") as! LabelRow).cell.backgroundColor = newColor
                (self.form.rowByTag("Color") as! LabelRow).value = "#\(Int(row.value!).toHex())\(Int((self.form.rowByTag("Green") as! SliderRow).value!).toHex())\(Int((self.form.rowByTag("Blue") as! SliderRow).value!).toHex())"
                (self.form.rowByTag("Color") as! LabelRow).updateCell()
                /*row.cell.backgroundColor = newColor
                (self.form.rowByTag("Green") as? SliderRow)?.cell.backgroundColor = newColor
                (self.form.rowByTag("Blue") as? SliderRow)?.cell.backgroundColor = newColor*/
            })
            <<< SliderRow("Green") { row in
                row.title = "Amount of green:"
                row.value = Float(CGColorGetComponents(oldColor.CGColor)[1])*255
                row.minimumValue = 0
                row.maximumValue = 255
                row.steps = 255
                //row.cell.backgroundColor = oldColor
                row.hidden = true
            }.onChange({ (row) in
                 let newColor = UIColor(colorLiteralRed: (self.form.rowByTag("Red") as! SliderRow).value!/255, green: row.value!/255, blue: (self.form.rowByTag("Blue") as! SliderRow).value!/255, alpha: 1.0)
                (self.form.rowByTag("Color") as! LabelRow).cell.backgroundColor = newColor
                (self.form.rowByTag("Color") as! LabelRow).value = "#\(Int((self.form.rowByTag("Red") as! SliderRow).value!).toHex())\(Int(row.value!).toHex())\(Int((self.form.rowByTag("Blue") as! SliderRow).value!).toHex())"
                (self.form.rowByTag("Color") as! LabelRow).updateCell()
                /*row.cell.backgroundColor = newColor
                (self.form.rowByTag("Red") as? SliderRow)?.cell.backgroundColor = newColor
                (self.form.rowByTag("Blue") as? SliderRow)?.cell.backgroundColor = newColor*/
            })
            <<< SliderRow("Blue") { row in
                row.title = "Amount of blue:"
                row.value = Float(CGColorGetComponents(oldColor.CGColor)[2])*255
                row.minimumValue = 0
                row.maximumValue = 255
                row.steps = 255
                //row.cell.backgroundColor = oldColor
                row.hidden = true
            }.onChange({ (row) in
                let newColor = UIColor(colorLiteralRed: (self.form.rowByTag("Red") as! SliderRow).value!/255, green: (self.form.rowByTag("Green") as! SliderRow).value!/255, blue: row.value!/255, alpha: 1.0)
                (self.form.rowByTag("Color") as! LabelRow).cell.backgroundColor = newColor
                (self.form.rowByTag("Color") as! LabelRow).value = "#\(Int((self.form.rowByTag("Red") as! SliderRow).value!).toHex())\(Int((self.form.rowByTag("Green") as! SliderRow).value!).toHex())\(Int(row.value!).toHex())"
                (self.form.rowByTag("Color") as! LabelRow).updateCell()
                /*row.cell.backgroundColor = newColor
                (self.form.rowByTag("Red") as? SliderRow)?.cell.backgroundColor = newColor
                (self.form.rowByTag("Green") as? SliderRow)?.cell.backgroundColor = newColor*/
            })
            +++ Section()
        if !edit {
            (form.rowByTag("Name") as? TextFloatLabelRow)?.cell.setFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        if let name = (form.rowByTag("Name") as? TextFloatLabelRow)?.value {
            if let number = (form.rowByTag("Number") as? IntFloatLabelRow)?.value {
                if let date = (form.rowByTag("Birthday") as? DateRow)?.value {
                    //let person = Person.MR_createEntity()
                    MagicalRecord.saveWithBlock({ (context) in
                        var localPerson : Person? = nil
                        if !self.edit {
                            localPerson = Person.MR_createEntityInContext(context)
                        } else {
                            let array = Person.MR_findByAttribute("name", withValue: self.name, inContext: context)
                            //let array = Person.MR_findByAttribute("name", withValue: self.name)
                            for person in array! {
                                if person is Person {
                                    let myperson = person as! Person
                                    if myperson.color == self.color && myperson.number == self.number {
                                        localPerson = myperson
                                        print("got local")
                                    }
                                }
                            }
                        }
                        if let actualPerson = localPerson {
                            actualPerson.name = name
                            let colorHexString = "#\(Int((self.form.rowByTag("Red") as! SliderRow).value!).toHex())\(Int((self.form.rowByTag("Green") as! SliderRow).value!).toHex())\(Int((self.form.rowByTag("Blue") as! SliderRow).value!).toHex())"
                            actualPerson.color = colorHexString
                            print(colorHexString)
                            actualPerson.number = NSNumber(integer: number)
                            actualPerson.birthday = date
                            
                            //Local notification
                            let notifications = UIApplication.sharedApplication().scheduledLocalNotifications!
                            for notification in notifications {
                                if notification.category! == "\(name)'s birthday" {
                                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                                }
                            }
                            let zeroDate = date.getDateWithHour(0, minutes: 0, seconds: 0)
                            //let components = NSCalendar.currentCalendar().components([.Year], fromDate: zeroDate, toDate: NSDate(), options: NSCalendarOptions.MatchLast)
                            let notification = UILocalNotification()
                            notification.fireDate = zeroDate
                            notification.alertBody = "Today is \(name)'s birthday!"
                            notification.soundName = "Default";
                            notification.timeZone = NSTimeZone.systemTimeZone()
                            notification.category = "\(name)'s birthday"
                            notification.repeatInterval = NSCalendarUnit.Year
                            UIApplication.sharedApplication().scheduleLocalNotification(notification)
                        }
                        }, completion: { (success, error) in
                            if success {
                                print("saved \(name)")
                            } else {
                                print(error)
                            }
                            if !self.edit {
                                self.dismissViewControllerAnimated(true, completion: {
                                    //nothing, but maybe one day something
                                })
                            } else {
                                let redRow = self.form.rowByTag("Red") as! SliderRow
                                let greenRow = self.form.rowByTag("Green") as! SliderRow
                                let blueRow = self.form.rowByTag("Blue") as! SliderRow
                                redRow.hidden = true
                                greenRow.hidden = true
                                blueRow.hidden = true
                                redRow.evaluateHidden()
                                greenRow.evaluateHidden()
                                blueRow.evaluateHidden()
                            }
                    })
                }
            }
        }
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {
            //nothing, but maybe one day something
        })
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
