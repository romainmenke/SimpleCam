//
//  Alerts.swift
//  SimpleCam
//
//  Created by Romain Menke on 30/01/16.
//  Copyright © 2016 Romain Menke. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    /**
     Display Alert when the ImagePicker sourceType is unavailable
     
     - parameter source: UIImagePickerControllerSourceType
     */
    func cantOpenPicker(withSource source:UIImagePickerControllerSourceType) {
        
        let sourceName : String
        
        switch source {
        case .camera : sourceName = "Camera"
        case .photoLibrary : sourceName = "Photo Library"
        case .savedPhotosAlbum : sourceName = "Saved Photos Album"
        }
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        let alertVC = UIAlertController(title: "Sorry", message: "Can't access your \(sourceName)", preferredStyle: .alert)
        
        alertVC.addAction(alertAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /**
     Display Alert when loadImages had no results
     */
    func noImagesFound() {
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        let alertVC = UIAlertController(title: "No Images Found", message: "There were no images saved in Core Data", preferredStyle: .alert)
        
        alertVC.addAction(alertAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
