//
//  Thumbnail+CoreDataProperties.swift
//  SimpleCam
//
//  Created by Romain Menke on 03/11/15.
//  Copyright © 2015 Romain Menke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Thumbnail {

    @NSManaged var imageData: Data?
    @NSManaged var id: NSNumber?
    @NSManaged var fullRes: NSManagedObject?

}
