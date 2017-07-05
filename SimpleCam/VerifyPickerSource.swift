//
//  VerifyPickerSource.swift
//  SimpleCam
//
//  Created by Romain Menke on 30/01/16.
//  Copyright © 2016 Romain Menke. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

extension ViewController {
    
    /**
     Verify Source for UIImagePickerController
     
     - parameter alert: show Alert if check fails
     
     - returns: true if Source is available
     */
    func canStartPicker(forSource source: UIImagePickerControllerSourceType, withAlert alert:Bool) -> Bool {
        
        let result = pickerCanStart(withSource: source)
        if !result && alert {
            cantOpenPicker(withSource: source)
        }
        return result
    }
    
    fileprivate func pickerCanStart(withSource source:UIImagePickerControllerSourceType) -> Bool {
        
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            return false
        }
        guard let sourceTypes = UIImagePickerController.availableMediaTypes(for: source), sourceTypes.contains(String(kUTTypeImage)) else {
            return false
        }
        
        return true
    }
}
