//
//  UIImageExtensions.swift
//  SimpleCam
//
//  Created by Romain Menke on 29/12/15.
//  Copyright © 2015 Romain Menke. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func scale(toSize newSize:CGSize) -> UIImage {
        
        // make sure the new size has the correct aspect ratio
        let aspectFill = self.size.resizeFill(newSize)
        
        UIGraphicsBeginImageContextWithOptions(aspectFill, false, 0.0);
        self.drawInRect(CGRectMake(0, 0, aspectFill.width, aspectFill.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}