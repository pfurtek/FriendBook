//
//  Person+CoreDataProperties.swift
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

extension Person {

    @NSManaged var color: String?
    @NSManaged var name: String?
    @NSManaged var number: NSNumber?
    @NSManaged var birthday: NSDate?
    @NSManaged var date: NSSet?

}
