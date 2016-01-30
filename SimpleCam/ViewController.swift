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
    
    /// The UIImageView to display loaded images.
    @IBOutlet weak var imageView: UIImageView!

    /// The UIImagePickerController to capture or load image.
    var imagePicker : UIImagePickerController?
    
    /// A dispatch queue to convert images to jpeg and to thumbnail size
    let convertQueue = dispatch_queue_create("convertQueue", DISPATCH_QUEUE_CONCURRENT)
    
    /// A dispatch queue for the Core Data managed context
    let saveQueue = dispatch_queue_create("saveQueue", DISPATCH_QUEUE_CONCURRENT)
    
    /// The Core Data managed context
    var managedContext : NSManagedObjectContext?
    
    /// The SourceType for UIImagePickerController
    var sourceType : UIImagePickerControllerSourceType = .Camera // don't use camera in the simulator
    
    // This is the right moment in the ViewController Life Cycle to setup Core Data and the ImagePicker
    override func viewDidAppear(animated: Bool) {
        
        // verify source and assign value to imagePicker
        imagePickerSetup(forSource: sourceType)
        
        // setup Core Data on the correct thread
        coreDataSetup()
        
        // else images will appear distorted
        imageView.contentMode = .ScaleAspectFit
    }
    
    /**
     CaptureButtonAction
     
     - parameter sender: UIButton
     */
    @IBAction func capture(sender: AnyObject) {
        
        // unwrap the imagePicker
        guard let imagePicker = imagePicker else {
            cantOpenPicker(withSource: sourceType)
            return
        }
        
        // present the imagePicker
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    /**
     LoadButtonAction
     
     - parameter sender: UIButton
     */
    @IBAction func load(sender: AnyObject) {
        
        // loadImage function with a completion block
        loadImages { (images) -> Void in
            if let thumbnailData = images?.last?.thumbnail?.imageData {
                let image = UIImage(data: thumbnailData)
                self.imageView.image = image
            } else {
                self.noImagesFound()
            }
        }
    }
}



