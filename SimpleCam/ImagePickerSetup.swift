//
//  ImagePickerSetup.swift
//  SimpleCam
//
//  Created by Romain Menke on 29/12/15.
//  Copyright © 2015 Romain Menke. All rights reserved.
//

import Foundation
import UIKit


extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
     Setup imagePicker and display Alert if it is not possible
     */
    func imagePickerSetup() {
        
        imagePickerSetup(forSource: .Camera)
        
    }
    
    /**
     Setup imagePicker and display Alert if it is not possible
     
     - parameter source: The Source for the imagePicker
     */
    func imagePickerSetup(forSource source : UIImagePickerControllerSourceType) {
        if canStartPicker(forSource: source, withAlert: true) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = source
            
            self.imagePicker = picker
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        prepareImageForSaving(image)
        
    }
}
