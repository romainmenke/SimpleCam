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
    
    func resizeFill(toSize: CGSize) -> CGSize {
        
        let aspectOne = self.height / self.width
        let aspectTwo = toSize.height / toSize.width
        
        let scale : CGFloat
        
        if aspectOne < aspectTwo {
            scale = self.height / toSize.height
        } else {
            scale = self.width / toSize.width
        }
        
        let newHeight = self.height / scale
        let newWidth = self.width / scale
        return CGSize(width: newWidth, height: newHeight)
        
    }
}