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

struct Const {
    struct CoreData {
        static let FullRes = "FullRes"
        static let Thumbnail = "Thumbnail"
    }
}

extension ViewController {
    
    /**
     Convert Image to JPEG and generate a thumbnail
     
     - parameter image: a captured image
     */
    func prepareImageForSaving(_ image:UIImage) {
        
        // use date as unique id
        let date : Double = Date().timeIntervalSince1970
        
        startActivity()
        // dispatch with gcd.
        Run.async(imageProcessingQueue) {
            
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
            
            self.stopActivity()
            
            // send to save function
            self.saveImage(imageData, thumbnailData: thumbnailData, date: date)
        }
    }
}

extension ViewController {

    /**
     Save image to Core Data
     
     - parameter imageData:     NSData representation of the original image
     - parameter thumbnailData: NSData representation of the thumbnail image
     - parameter date:          timestamp
     */
    func saveImage(_ imageData:Data, thumbnailData:Data, date: Double) {
        
        startActivity()
        
        // create new objects in moc
        Run.async(coreDataQueue) {
            guard let moc = self.managedContext else {
                return
            }
            
            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMOC.parent = moc
            
            privateMOC.perform {
                guard let fullRes = NSEntityDescription.insertNewObject(forEntityName: Const.CoreData.FullRes, into: privateMOC) as? FullRes, let thumbnail = NSEntityDescription.insertNewObject(forEntityName: Const.CoreData.Thumbnail, into: privateMOC) as? Thumbnail else {
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
                    try privateMOC.save()
                    
                    moc.performAndWait {
                        do {
                            try moc.save()
                            moc.refreshAllObjects()
                            self.stopActivity()
                        } catch {
                            fatalError("Failure to save context: \(error)")
                        }
                    }
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
    }
}

extension ViewController {
    
    /**
     Delete all images saved by the App
     
     - parameter done: Completion Block for the background delete.
     */
    func deleteAllImages(_ done: @escaping () -> Void) {
        
        startActivity()
        
        Run.async(coreDataQueue) {
            
            guard let moc = self.managedContext else {
                return
            }
            
            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMOC.parent = moc
            
            privateMOC.performAndWait {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Const.CoreData.Thumbnail)
                
                do {
                    let results = try privateMOC.fetch(fetchRequest)
                    
                    for item in results {
                        if let object = item as? NSManagedObject {
                            privateMOC.delete(object)
                        }
                    }
                } catch {
                    self.stopActivity()
                    Run.main {
                        done()
                    }
                    return
                }
                
                // save the delete op
                do {
                    try privateMOC.save()
                    
                    moc.performAndWait {
                        do {
                            try moc.save()
                            moc.refreshAllObjects()
                            self.stopActivity()
                            Run.main {
                                done()
                            }
                        } catch {
                            fatalError("Failure to save context: \(error)")
                        }
                    }
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
    }
}
