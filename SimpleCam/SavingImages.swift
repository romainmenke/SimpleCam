//
//  SavingImages.swift
//  SimpleCam
//
//  Created by Romain Menke on 29/12/15.
//  Copyright © 2015 Romain Menke. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ViewController {
    
    func prepareImageForSaving(image:UIImage) {
        
        // use date as unique id
        let date : Double = NSDate().timeIntervalSince1970
        
        
        // dispatch with gcd.
        dispatch_async(convertQueue) {
            
            // create NSData from UIImage
            guard let imageData = UIImageJPEGRepresentation(image, 1) else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            // scale image
            let thumbnail = image.scale(toSize: self.view.frame.size)
            
            guard let thumbnailData  = UIImageJPEGRepresentation(thumbnail, 0.7) else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            // send to save function
            self.saveImage(imageData, thumbnailData: thumbnailData, date: date)
            
        }
    }
}

extension ViewController {

    func saveImage(imageData:NSData, thumbnailData:NSData, date: Double) {
        
        dispatch_barrier_sync(saveQueue) {
            // create new objects in moc
            guard let moc = self.managedContext else {
                return
            }
            
            guard let fullRes = NSEntityDescription.insertNewObjectForEntityForName("FullRes", inManagedObjectContext: moc) as? FullRes, let thumbnail = NSEntityDescription.insertNewObjectForEntityForName("Thumbnail", inManagedObjectContext: moc) as? Thumbnail else {
                // handle failed new object in moc
                print("moc error")
                return
            }
            
            //set image data of fullres
            fullRes.imageData = imageData
            
            //set image data of thumbnail
            thumbnail.imageData = thumbnailData
            thumbnail.id = date as NSNumber
            thumbnail.fullRes = fullRes
            
            // save the new objects
            do {
                try moc.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // clear the moc
            moc.refreshAllObjects()
        }
    }
}