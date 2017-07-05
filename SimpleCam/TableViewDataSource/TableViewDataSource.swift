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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? ImageDisplayCell {
        
            cell.thumbnailView.image = data[indexPath.row].image
            let dateNumber = Double(data[indexPath.row].id)
            let date = Date(timeIntervalSince1970: dateNumber)
            cell.label.text = ImageDisplayCell.dateFormatter.string(from: date)
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
}
