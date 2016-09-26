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

    class func getExercisesDataFromFileWithSuccess(_ success: @escaping ((_ data: Data) -> Void)) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
            let filePath = Bundle.main.path(forResource: "exercises", ofType:"json")
            let data = try! Data(contentsOf: URL(fileURLWithPath: filePath!),
                options: NSData.ReadingOptions.uncached)
            success(data)
        })
    }

    func getMuscleGroupsDataFromFileWithSuccess(_ success: @escaping ((_ data: Data) -> Void)) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            let filePath = Bundle.main.path(forResource: "muscle-groups", ofType: "json")
            let data = try! Data(contentsOf: URL(fileURLWithPath: filePath!),
                                   options: NSData.ReadingOptions.uncached)
            success(data)
        }
    }

    class func getTrainingZonesDataFromFileWithSuccess(_ success: @escaping ((_ dict: NSDictionary) -> Void)) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            let filePath = Bundle.main.path(forResource: "ExerciseVolume", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: filePath!) as! [String: AnyObject]

            success(dict as NSDictionary)
        }
    }

}











