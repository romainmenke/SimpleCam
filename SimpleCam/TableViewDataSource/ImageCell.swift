//
//  ImageCell.swift
//  SimpleCam
//
//  Created by Romain Menke on 13/02/16.
//  Copyright © 2016 Romain Menke. All rights reserved.
//

import Foundation
import UIKit


class ImageDisplayCell : UITableViewCell {

    private static var storedDateFormatter : NSDateFormatter?
    static var dateFormatter : NSDateFormatter {
        if let storedDateFormatter = storedDateFormatter {
            return storedDateFormatter
        } else {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .ShortStyle
            storedDateFormatter = formatter
            return formatter
        }
    }

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        thumbnailView.layer.cornerRadius = thumbnailView.frame.width / 2
        thumbnailView.contentMode = .ScaleAspectFill
        thumbnailView.clipsToBounds = true
    }
    
}