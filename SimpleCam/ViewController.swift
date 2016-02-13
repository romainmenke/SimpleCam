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
    
    /// The UITableView to display loaded images.
    @IBOutlet weak var tableView : UITableView!
    /// Data Source for UITableView
    var tableViewDataSource = TableViewDataSource()

    /// The UIActivityIndicatorView to indicate long during tasks.
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    /// Button for capture action
    @IBOutlet weak var captureButton: UIButton!
    /// Button for load action
    @IBOutlet weak var loadButton: UIButton!

    /// The UIImagePickerController to capture or load image.
    var imagePicker : UIImagePickerController?
    
    /// A dispatch queue to convert images to jpeg and to thumbnail size
    let imageProcessingQueue = dispatch_queue_create("imageProcessingQueue", DISPATCH_QUEUE_CONCURRENT)
    
    /// A dispatch queue for the Core Data managed context
    let coreDataQueue = dispatch_queue_create("coreDataQueue", DISPATCH_QUEUE_CONCURRENT)
    
    /// The Core Data managed context
    var managedContext : NSManagedObjectContext?
    
    /// The SourceType for UIImagePickerController
    var sourceType : UIImagePickerControllerSourceType = .Camera // don't use camera in the simulator
    
    // This is the right moment in the ViewController Life Cycle to setup Core Data and the ImagePicker
    override func viewDidLoad() {
        // verify source and assign value to imagePicker
        imagePickerSetup(forSource: sourceType)
        
        // setup Core Data on the correct thread
        coreDataSetup()
        
        tableView.dataSource = tableViewDataSource
        
        captureButton.layer.cornerRadius = 10
        loadButton.layer.cornerRadius = 10
        
        activityIndicator.hidden = true
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
            if let images = images {
                
                let maybeThumbnails = images.map { $0.thumbnail }
                var thumbnails : [Thumbnail] = []
                
                for maybeThumbnail in maybeThumbnails {
                    if let thumbnail = maybeThumbnail {
                        
                        // filter out duplicates
                        let isDuplicate = self.tableViewDataSource.data.contains {
                            return $0.id == thumbnail.id
                        }
                        
                        if !isDuplicate { thumbnails.append(thumbnail) }
                        
                    }
                }
                
                var paths : [NSIndexPath] = []
                let start = self.tableViewDataSource.data.count
                self.tableViewDataSource.data += thumbnails.map { return (image:$0.image ?? UIImage(),id:$0.id ?? 0.0) }
                let end = self.tableViewDataSource.data.count
                
                for i in start..<end {
                    paths.append(NSIndexPath(forRow: i, inSection: 0))
                }
                
                // make sure it updates happen on the main thread
                Run.main {
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.Fade)
                    self.tableView.endUpdates()
                }
            } else {
                self.noImagesFound()
            }
        }
    }
}



