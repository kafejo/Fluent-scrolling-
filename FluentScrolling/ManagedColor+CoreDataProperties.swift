//
//  ManagedColor+CoreDataProperties.swift
//  FluentScrolling
//
//  Created by Aleš Kocur on 28/03/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ManagedColor {

    @NSManaged var name: String?
    @NSManaged var r: NSNumber?
    @NSManaged var g: NSNumber?
    @NSManaged var b: NSNumber?

}
