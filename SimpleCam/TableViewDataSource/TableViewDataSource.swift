//
//  TableViewDataSource.swift
//  SimpleCam
//
//  Created by Romain Menke on 13/02/16.
//  Copyright © 2016 Romain Menke. All rights reserved.
//

import Foundation
import UIKit

class TableViewDataSource : NSObject, UITableViewDataSource {
    
    var data : [(image:UIImage,id:NSNumber)] = []
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as? ImageDisplayCell {
        
            cell.thumbnailView.image = data[indexPath.row].image
            let dateNumber = Double(data[indexPath.row].id)
            let date = NSDate(timeIntervalSince1970: dateNumber)
            cell.label.text = ImageDisplayCell.dateFormatter.stringFromDate(date)
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
}