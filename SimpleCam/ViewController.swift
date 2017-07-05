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
    // Button to delete images
    @IBOutlet weak var deleteButton: UIButton!

    /// The UIImagePickerController to capture or load image.
    var imagePicker : UIImagePickerController?
    
    /// A dispatch queue to convert images to jpeg and to thumbnail size
    let imageProcessingQueue = DispatchQueue(label: "imageProcessingQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    /// A dispatch queue for the Core Data managed context
    let coreDataQueue = DispatchQueue(label: "coreDataQueue")
    
    /// The Core Data managed context
    var managedContext : NSManagedObjectContext?
    
    /// The SourceType for UIImagePickerController
    var sourceType : UIImagePickerControllerSourceType = .camera // don't use camera in the simulator
    
    // This is the right moment in the ViewController Life Cycle to setup Core Data and the ImagePicker
    override func viewDidLoad() {
        // verify source and assign value to imagePicker
        imagePickerSetup(forSource: sourceType)
        
        // setup Core Data on the correct thread
        coreDataSetup()
        
        tableView.dataSource = tableViewDataSource
        
        captureButton.layer.cornerRadius = 10
        loadButton.layer.cornerRadius = 10
        deleteButton.layer.cornerRadius = 10
        
        activityIndicator.isHidden = true
    }
    
    /**
     CaptureButtonAction
     
     - parameter sender: UIButton
     */
    @IBAction func capture(_ sender: AnyObject) {
        
        // unwrap the imagePicker
        guard let imagePicker = imagePicker else {
            cantOpenPicker(withSource: sourceType)
            return
        }
        
        // present the imagePicker
        present(imagePicker, animated: true, completion: nil)
    }
    
    /**
     LoadButtonAction
     
     - parameter sender: UIButton
     */
    @IBAction func load(_ sender: AnyObject) {
        
        // loadImage function with a completion block
        loadImages { (thumbnails) -> Void in
                
            var newThumbnails : [Thumbnail] = []
            
            for thumbnail in thumbnails {
                    
                // filter out duplicates
                let isDuplicate = self.tableViewDataSource.data.contains {
                    return $0.id == thumbnail.id
                }
                
                if !isDuplicate {
                    newThumbnails.append(thumbnail)
                }
            }
            
            var paths : [IndexPath] = []
            let start = self.tableViewDataSource.data.count
            self.tableViewDataSource.data += newThumbnails.map { return (image:$0.image ?? UIImage(),id:$0.id ?? 0.0) }
            let end = self.tableViewDataSource.data.count
            
            for i in start..<end {
                paths.append(IndexPath(row: i, section: 0))
            }
            
            // make sure it updates happen on the main thread
            Run.main {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: paths, with: UITableViewRowAnimation.fade)
                self.tableView.endUpdates()
            }
        }
    }
    
    @IBAction func deleteImages(_ sender: AnyObject) {
        self.deleteAllImages {
            self.tableViewDataSource.data.removeAll()
            self.tableView.reloadData()
        }
    }
}



