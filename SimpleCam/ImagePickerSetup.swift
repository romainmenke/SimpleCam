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
    
    func imagePickerSetup() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        prepareImageForSaving(image)
        
    }
}
