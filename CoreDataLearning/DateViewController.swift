//
//  DateViewController.swift
//  CoreDataLearning
//
//  Created by Pawel Furtek on 7/24/16.
//  Copyright © 2016 Pawel Furtek. All rights reserved.
//

import UIKit
import Eureka
import MagicalRecord

class DateViewController: FormViewController {
    
    var person: Person?
    var dates: NSSet?
    var amount = 0
    var lastSelected = 0
    var hiddenArray = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dates = person!.date
        //amount = dates!.count
        
        for date in dates! {
            if date is Date {
                self.addSection(date as! Date)
            }
        }
        
        print("hidden")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {
            //nothing, but maybe one day something
        })
    }
    
    @IBAction func saveClicked(sender: AnyObject) {
        MagicalRecord.saveWithBlock({ (context) in
            let myPerson = self.person!.MR_inContext(context)
            let sections = self.form.allSections
            var index = 0
            myPerson?.mutableSetValueForKey("date").removeAllObjects()
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
                print(notification.category!)
                if notification.category! == self.person!.name! {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                }
            }
            for section in sections {
                if !self.hiddenArray[index] {
                    let current = (section as! MySection).currentAmount
                    print("current \(current!)")
                    let textrow = self.form.rowByTag("Title\(current!)") as! TextRow
                    if let title = textrow.value {
                        let daterow = self.form.rowByTag("Date\(current!)") as! DateInlineRow
                        if let date = daterow.value {
                            let zeroDate = date.getDateWithHour(0, minutes: 0, seconds: 0)
                            let newDate = Date.MR_createEntityInContext(context)
                            let components = NSCalendar.currentCalendar().components([.Year], fromDate: zeroDate, toDate: NSDate(), options: NSCalendarOptions.MatchLast)
                            print(components.year)
                            newDate?.date = zeroDate
                            newDate?.type = title
                            myPerson?.mutableSetValueForKey("date").addObject(newDate!)
                            print("zero date")
                            print(zeroDate.description)
                            print("this year")
                            print(zeroDate.thisYear().description)
                            let notification = UILocalNotification()
                            notification.fireDate = zeroDate.thisYear()//NSDate().dateByAddingTimeInterval(60)
                            notification.alertBody = "Today is \(self.person!.name!)'s \(title)"
                            notification.soundName = "Default";
                            notification.timeZone = NSTimeZone.systemTimeZone()
                            notification.category = self.person!.name!
                            notification.repeatInterval = NSCalendarUnit.Year
                            UIApplication.sharedApplication().scheduleLocalNotification(notification)
                        }
                    }
                }
                index+=1
            }
            }) { (success, error) in
                if success {
                    print("saved")
                } else {
                    print(error)
                }
                self.form.hideInlineRows()
                /*self.dismissViewControllerAnimated(true, completion: {
                    //nothing, but maybe one day something
                })*/
        }
    }
    
    @IBAction func addClicked(sender: AnyObject) {
        self.hiddenArray.append(false)
        let currentAmount = self.amount
        form = form
            +++ MySection() { section in
                section.header?.title = ""
                (section as! MySection).currentAmount = currentAmount
                //section.hidden = Condition.init(stringLiteral: "self.hiddenArray[currentAmount]")
            }
            <<< TextRow("Title\(amount)") { row in
                row.title = "Title:"
                row.cell.textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
                }.onCellSelection({ (cell, row) in
                    self.lastSelected = currentAmount
                    print(currentAmount)
                }).onCellHighlight({ (cell, row) in
                    self.lastSelected = currentAmount
                    print(currentAmount)
                })
            <<< DateInlineRow("Date\(amount)") { row in
                row.title = "Date:"
                }.onCellSelection({ (cell, row) in
                    self.lastSelected = currentAmount
                }).onCellHighlight({ (cell, row) in
                    self.lastSelected = currentAmount
                    print(currentAmount)
                }).onExpandInlineRow({ (cell, inline, picker) in
                    self.lastSelected = currentAmount
                    print(currentAmount)
                })
        print("created \(currentAmount)")
        amount+=1
        lastSelected = currentAmount
    }
    
    @IBAction func trashClicked(sender: AnyObject) {
        print("trash")
        print(lastSelected)
        print("hidden array: \(hiddenArray.count)")
        if hiddenArray.count == 0 {
            return
        }
        hiddenArray[lastSelected] = true
        let section = form.rowByTag("Date\(self.lastSelected)")?.section
        section?.hidden = true
        section?.evaluateHidden()
        var index = 0
        for value in hiddenArray {
            if !value {
                lastSelected = index
            }
            index+=1
        }
    }
    
    func addSection(date: Date) {
        self.hiddenArray.append(false)
        let currentAmount = self.amount
        form = form
            +++ MySection() { section in
                section.header?.title = ""
                (section as! MySection).currentAmount = currentAmount
                //section.hidden = Condition.init(stringLiteral: "self.hiddenArray[currentAmount]")
            }
            <<< TextRow("Title\(amount)") { row in
                row.title = "Title:"
                row.value = date.type
                row.cell.textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
                }.onCellSelection({ (cell, row) in
                    self.lastSelected = currentAmount
                    print(currentAmount)
                }).onCellHighlight({ (cell, row) in
                    self.lastSelected = currentAmount
                    print(currentAmount)
                })
            <<< DateInlineRow("Date\(amount)") { row in
                row.title = "Date:"
                row.value = date.date
                }.onCellSelection({ (cell, row) in
                    self.lastSelected = currentAmount
                }).onCellHighlight({ (cell, row) in
                    self.lastSelected = currentAmount
                    print(currentAmount)
                }).onExpandInlineRow({ (cell, inline, picker) in
                    self.lastSelected = currentAmount
                    print(currentAmount)
                })
        print("created \(currentAmount)")
        amount+=1
        lastSelected = currentAmount
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

class MySection: Section {
    var currentAmount: Int?
}

extension NSDate {
    func getDateWithHour(hour: Int, minutes: Int, seconds: Int) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: self)
        components.hour = hour
        components.minute = minutes
        components.second = seconds
        return calendar.dateFromComponents(components)!
    }
    
    func thisYear() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Hour, .Minute, .Second], fromDate: self)
        let todayComponents = calendar.components([.Year], fromDate: NSDate())
        components.year = todayComponents.year
        return calendar.dateFromComponents(components)!
    }
}

extension Int {
    func toTh() -> String {
        if self == 1 || (self > 20 && self%10 == 1) {
            return "\(self)st"
        } else if self == 2 || (self > 20 && self%10 == 2) {
            return "\(self)nd"
        } else if self == 3 || (self > 20 && self%10 == 3) {
            return "\(self)rd"
        } else {
            return "\(self)th"
        }
    }
}
