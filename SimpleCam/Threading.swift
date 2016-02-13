//
//  File.swift
//  SimpleCam
//
//  Created by Romain Menke on 12/02/16.
//  Copyright © 2016 Romain Menke. All rights reserved.
//

import Foundation

/**
 *  Convenience methods for GCD
 */
struct Run {
    
    /**
     Run Syncronous task
     
     - parameter queue: Queue for the task to run on
     - parameter task:  the Task to be executed
     */
    static func sync(queue: dispatch_queue_t,task:() -> Void) {
        dispatch_sync(queue) {
            task()
        }
    }
    
    /**
     Run Asyncronous task
     
     - parameter queue: Queue for the task to run on
     - parameter task:  the Task to be executed
     */
    static func async(queue: dispatch_queue_t,task:() -> Void) {
        dispatch_async(queue) {
            task()
        }
    }
    
    /**
     Run Syncronous task with a Barrier
     
     - parameter queue: Queue for the task to run on
     - parameter task:  the Task to be executed
     */
    static func barrierSync(queue: dispatch_queue_t,task:() -> Void) {
        dispatch_barrier_sync(queue) {
            task()
        }
    }
    
    /**
     Run a task on the Main Thread
     
     - parameter task:  the Task to be executed
     */
    static func main(task:() -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            task()
        }
    }
}