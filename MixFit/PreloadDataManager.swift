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

    var coreDataStack: CoreDataStack!

    func preloadAppData() {

        preloadExerciseAndMuscleGroupData { () -> Void in
            print("Finished loading muscle groups and exercises.")
            self.loadTrainingZones()
        }

    }

    // MARK: - Muscle Groups & Exercises

    func preloadExerciseAndMuscleGroupData(completion: () -> Void) {
        guard let entity = NSEntityDescription.entityForName("MuscleGroup", inManagedObjectContext: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity descriptions!")
        }

        // Back
        let back = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        back.name = "Back"
        back.orderTag = "0"

        // Chest
        let chest = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        chest.name = "Chest"
        chest.orderTag = "1"

        // Legs subGroups
        // Quads
        let quads = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        quads.name = "Quads"
        quads.orderTag = "0"
        //Hamstrings
        let hamstrings = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        hamstrings.name = "Hamstrings"
        hamstrings.orderTag = "1"
        // Glutes
        let glutes = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        glutes.name = "Glutes"
        glutes.orderTag = "2"
        // Calves
        let calves = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        calves.name = "Calves"
        calves.orderTag = "3"

        // Legs
        let legs = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        legs.name = "Legs"
        legs.orderTag = "2"
        // Add subGroup relationships to Legs
        let legSubMuscleGroups = legs.mutableSetValueForKey("subMuscleGroups")
        legSubMuscleGroups.addObject(hamstrings)
        legSubMuscleGroups.addObject(quads)
        legSubMuscleGroups.addObject(glutes)
        legSubMuscleGroups.addObject(calves)

        // Arms subGroups
        // Biceps
        let biceps = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        biceps.name = "Biceps"
        biceps.orderTag = "0"
        // Triceps
        let triceps = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        triceps.name = "Triceps"
        triceps.orderTag = "1"

        // Arms
        let arms = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        arms.name = "Arms"
        arms.orderTag = "3"
        // Add subGroup relationships to Arms
        let armsSubMuscleGroups = arms.mutableSetValueForKey("subMuscleGroups")
        armsSubMuscleGroups.addObject(biceps)
        armsSubMuscleGroups.addObject(triceps)

        // Shoulders
        let shoulders = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        shoulders.name = "Shoulders"
        shoulders.orderTag = "4"

        // Core
        let core = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        core.name = "Core"
        core.orderTag = "5"

        // Full Body
        let fullBody = MuscleGroup(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        fullBody.name = "Full Body"
        fullBody.orderTag = "6"

        coreDataStack.saveMainContext()

        DataManager.getExercisesDataFromFileWithSuccess { (data) in

            var json: Payload!

            do {
                json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? Payload
            } catch {
                print(error)
                fatalError("Error paring JSON file!")
            }

            self.loadExercisesFromJSON("back", json: json, muscleGroup: back)
            self.loadExercisesFromJSON("chest", json: json, muscleGroup: chest)
            self.loadExercisesFromJSON("quads", json: json, muscleGroup: quads)
            self.loadExercisesFromJSON("hamstrings", json: json, muscleGroup: hamstrings)
            self.loadExercisesFromJSON("glutes", json: json, muscleGroup: glutes)
            self.loadExercisesFromJSON("calves", json: json, muscleGroup: calves)
            self.loadExercisesFromJSON("biceps", json: json, muscleGroup: biceps)
            self.loadExercisesFromJSON("triceps", json: json, muscleGroup: triceps)
            self.loadExercisesFromJSON("shoulders", json: json, muscleGroup: shoulders)
            self.loadExercisesFromJSON("core", json: json, muscleGroup: core)
            self.loadExercisesFromJSON("fullBody", json: json, muscleGroup: fullBody)
        }

        dispatch_async(dispatch_get_main_queue()) { 
            completion()
        }
    }

    func loadExercisesFromJSON(keyName: String, json: Payload, muscleGroup: MuscleGroup) {

        guard let entity = NSEntityDescription.entityForName("DefaultExercise", inManagedObjectContext: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity descriptions!")
        }

        guard let exercises = json[keyName] as? [Payload]
            else {
                fatalError("Error parsing JSON file!")
        }

        for dict in exercises {

            guard let exerciseID = dict["exerciseID"] as? String,
                let name = dict["name"] as? String,
                let imageName = dict["imageName"] as? String,
                let detailDescription = dict["exerciseDescription"] as? String,
                let targetedMuscleGroups = dict["targetedMuscleGroups"] as? String
                else {
                    fatalError("Error parsing exercise dictionary!")
            }

            let exercise = DefaultExercise(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
            exercise.exerciseID = exerciseID
            exercise.name = name
            exercise.isFavorite = false
            exercise.imageName = imageName
            exercise.detailDescription = detailDescription
            exercise.targetedMuscleGroups = targetedMuscleGroups
            exercise.setValue(muscleGroup, forKey: "muscleGroup")
        }
        
        coreDataStack.saveMainContext()
    }

    // MARK: - Training Zones

    func loadTrainingZones() {

        DataManager.getTrainingZonesDataFromFileWithSuccess{ (dict) in

            let trainingZones = ["Hypertrophy", "Power", "Strength", "Endurance"]

            for zone in trainingZones {
                self.loadExerciseVolumesFromPlist(zone, dict: dict)
            }

        }

    }

    func loadExerciseVolumesFromPlist(keyName: String, dict: NSDictionary) {
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







