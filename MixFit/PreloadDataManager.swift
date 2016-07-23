//
//  PreloadDataManager.swift
//  MixFit
//
//  Created by Kellen Pierson on 7/23/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import Foundation
import CoreData

class PreloadDataManager {


    func loadTrainingZonesWithCoreDataStack(coreDataStack: CoreDataStack) {

        DataManager.getTrainingZonesDataFromFileWithSuccess{ (dict) in

            let trainingZones = ["Hypertrophy", "Power", "Strength", "Endurance"]

            for zone in trainingZones {
                self.loadExerciseVolumesFromPlist(zone, dict: dict, coreDataStack: coreDataStack)
            }

        }

    }

    func loadExerciseVolumesFromPlist(keyName: String, dict: NSDictionary, coreDataStack: CoreDataStack) {
        guard let entity = NSEntityDescription.entityForName("ExerciseVolume", inManagedObjectContext: coreDataStack.managedObjectContext), let zoneEntity = NSEntityDescription.entityForName("TrainingZone", inManagedObjectContext: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity descriptions!")
        }

        let trainingZone = TrainingZone(entity: zoneEntity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        trainingZone.name = keyName
        trainingZone.isActive = true
        let exerciseVolumesRelation = trainingZone.mutableSetValueForKey("exerciseVolumes")

        guard let exerciseVolumes = dict[keyName.lowercaseString] as? [[String: AnyObject]]
            else {
                fatalError("Error parsing plist")
        }

        for dict in exerciseVolumes {
            guard let sets = dict["sets"] as? String,
            let reps = dict["reps"] as? String,
            let restTime = dict["restTime"] as? String
                else {
                    fatalError("Error parsing exerciseVolumes dictionary")
            }

            let exerciseVolume = ExerciseVolume(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
            exerciseVolume.sets = sets
            exerciseVolume.reps = reps
            exerciseVolume.restTime = restTime

            exerciseVolumesRelation.addObject(exerciseVolume)
        }

        coreDataStack.saveMainContext()
    }

}







