//
//  ViewController.swift
//  SimpleCam
//
//  Created by Romain Menke on 03/11/15.
//  Copyright © 2015 Romain Menke. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // imageview to display loaded image
    @IBOutlet weak var imageView: UIImageView!

    // image picker for capture / load
    let imagePicker = UIImagePickerController()
    
    // dispatch queues
    let convertQueue = dispatch_queue_create("convertQueue", DISPATCH_QUEUE_CONCURRENT)
    let saveQueue = dispatch_queue_create("saveQueue", DISPATCH_QUEUE_CONCURRENT)
    
    // moc
    var managedContext : NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerSetup() // image picker delegate and settings
        
        coreDataSetup() // set value of moc on the right thread

    }
    
    @IBAction func capture(sender: AnyObject) { // button action
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func load(sender: AnyObject) { // button action
        
        loadImages { (images) -> Void in
            if let thumbnailData = images?.last?.thumbnail?.imageData {
                let image = UIImage(data: thumbnailData)
                self.imageView.image = image
            }
        }
    }
}



