//
//  LoadingImages.swift
//  SimpleCam
//
//  Created by Romain Menke on 29/12/15.
//  Copyright © 2015 Romain Menke. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension ViewController {
    
    func loadImages(fetched:(images:[FullRes]?) -> Void) {
        
        dispatch_async(saveQueue) {
            guard let moc = self.managedContext else {
                return
            }
            
            let fetchRequest = NSFetchRequest(entityName: "FullRes")
            
            do {
                let results = try moc.executeFetchRequest(fetchRequest)
                let imageData = results as? [FullRes]
                dispatch_async(dispatch_get_main_queue()) {
                    fetched(images: imageData)
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
                return
            }
        }
    }
}