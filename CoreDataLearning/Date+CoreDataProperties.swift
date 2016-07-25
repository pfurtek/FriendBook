//
//  Date+CoreDataProperties.swift
//  
//
//  Created by Pawel Furtek on 7/24/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Date {

    @NSManaged var date: NSDate?
    @NSManaged var type: String?
    @NSManaged var anniversary: NSNumber?
    @NSManaged var person: Person?

}
