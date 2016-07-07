//
//  DataManager.swift
//  MixFit
//
//  Created by Kellen Pierson on 7/6/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import Foundation
import CoreData

typealias Payload = [String:AnyObject]

class DataManager {

    class func getExercisesDataFromFileWithSuccess(success: ((data: NSData) -> Void)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let filePath = NSBundle.mainBundle().pathForResource("exercises", ofType:"json")
            let data = try! NSData(contentsOfFile:filePath!,
                options: NSDataReadingOptions.DataReadingUncached)
            success(data: data)
        })
    }

    func getMuscleGroupsDataFromFileWithSuccess(success: ((data: NSData) -> Void)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let filePath = NSBundle.mainBundle().pathForResource("muscle-groups", ofType: "json")
            let data = try! NSData(contentsOfFile: filePath!,
                                   options: NSDataReadingOptions.DataReadingUncached)
            success(data: data)
        }
    }

}











