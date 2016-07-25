//
//  ViewController.swift
//  CoreDataLearning
//
//  Created by Pawel Furtek on 7/23/16.
//  Copyright © 2016 Pawel Furtek. All rights reserved.
//

import UIKit
import MagicalRecord

class ViewController: UITableViewController {
    
    var objects : [Person] = []
    var lastSelected : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        let foundings = Person.MR_findAllSortedBy("name", ascending: true)
        print(foundings?.count)
        objects = foundings as! [Person]
        print(objects.count)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell?.textLabel?.text = objects[indexPath.row].name
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month], fromDate: objects[indexPath.row].birthday!)
        cell?.detailTextLabel?.text = "🎂: \(components.month)/\(components.day)"
        cell?.backgroundColor = UIColor(hex: objects[indexPath.row].color!, alpha: 1.0)
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        lastSelected = indexPath.row
        return indexPath
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            MagicalRecord.saveWithBlock({ (context) in
                self.objects[indexPath.row].MR_deleteEntityInContext(context)
                }, completion: { (success, error) in
                    if success {
                        print("successfully deleted")
                    } else {
                        print(error)
                    }
                    self.objects.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "DetailSegue" {
            print("detail segue")
            let tabview = segue.destinationViewController as! UITabBarController
            let navigation1 = tabview.viewControllers![0] as! UINavigationController
            let destination1 = navigation1.viewControllers[0] as! AddChangeViewController
            destination1.name = objects[lastSelected].name!
            destination1.color = objects[lastSelected].color!
            destination1.number = objects[lastSelected].number!
            destination1.date = objects[lastSelected].birthday!
            destination1.edit = true
            let navigation2 = tabview.viewControllers![1] as! UINavigationController
            let destination2 = navigation2.viewControllers[0] as! DateViewController
            destination2.person = objects[lastSelected]
        }
//        if segue.identifier == "EditSegue" {
//            print("edit segue")
//            if segue.destinationViewController is UINavigationController {
//                let navigation = segue.destinationViewController as! UINavigationController
//                if navigation.viewControllers.first is AddChangeViewController {
//                    print("addchange")
//                    let destination = navigation.viewControllers.first as! AddChangeViewController
//                    destination.name = objects[lastSelected].name!
//                    destination.color = objects[lastSelected].color!
//                    destination.number = objects[lastSelected].number!
//                    destination.edit = true
//                }
//                
//            }
//        }
     }
 

}

extension Int {
    func toHex() -> String {
        if self<16 {
            return "\(String(format:"%X", self))\(String(format:"%X", self))"
        } else {
            return String(format:"%2X", self)
        }
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = NSScanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}

