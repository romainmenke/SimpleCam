//
//  CoreDataSetup.swift
//  SimpleCam
//
//  Created by Romain Menke on 29/12/15.
//  Copyright © 2015 Romain Menke. All rights reserved.
//

import Foundation
import CoreData
import UIKit


extension ViewController {
    
    /**
     Start Core Data managed context on the correct queue
     */
    func coreDataSetup() {
        
        dispatch_sync(saveQueue) {
            self.managedContext = AppDelegate().managedObjectContext
        }
        
    }
}
