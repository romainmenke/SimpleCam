//
//  CGSizeExtension.swift
//  SimpleCam
//
//  Created by Romain Menke on 29/12/15.
//  Copyright © 2015 Romain Menke. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    
    /**
     Calculate scaled size with the same aspect ratio
     
     - parameter toSize: target size
     
     - returns: scaled size
     */
    func resizeFill(_ toSize: CGSize) -> CGSize {
        
        let scale : CGFloat = (self.height / self.width) < (toSize.height / toSize.width) ? (self.height / toSize.height) : (self.width / toSize.width)
        return CGSize(width: (self.width / scale), height: (self.height / scale))
        
    }
}
