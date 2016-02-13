//
//  ActivityIndicator.swift
//  SimpleCam
//
//  Created by Romain Menke on 13/02/16.
//  Copyright © 2016 Romain Menke. All rights reserved.
//

import Foundation


extension ViewController {
    
    func startActivity() {
        Run.main {
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopActivity() {
        Run.main {
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}