//
//  Thumbnail-UIImage.swift
//  SimpleCam
//
//  Created by Romain Menke on 12/02/16.
//  Copyright © 2016 Romain Menke. All rights reserved.
//

import Foundation
import UIKit

extension Thumbnail {
    
    /// Convenience Property to get set the imageDate with a UIImage
    var image : UIImage? {
        get {
            if let imageData = imageData {
                return UIImage(data: imageData as Data)
            }
            return nil
        }
        set(value) {
            if let value = value {
                imageData = UIImageJPEGRepresentation(value, 0.7)
            }
        }
    }
}
