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

    func preloadExerciseAndMuscleGroupData(_ completion: @escaping () -> Void) {
        guard let entity = NSEntityDescription.entity(forEntityName: "MuscleGroup", in: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity descriptions!")
        }

        // Back
        let back = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        back.name = "Back"
        back.orderTag = "0"

        // Chest
        let chest = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        chest.name = "Chest"
        chest.orderTag = "1"

        // Legs subGroups
        // Quads
        let quads = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        quads.name = "Quads"
        quads.orderTag = "0"
        //Hamstrings
        let hamstrings = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        hamstrings.name = "Hamstrings"
        hamstrings.orderTag = "1"
        // Glutes
        let glutes = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        glutes.name = "Glutes"
        glutes.orderTag = "2"
        // Calves
        let calves = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        calves.name = "Calves"
        calves.orderTag = "3"

        // Legs
        let legs = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        legs.name = "Legs"
        legs.orderTag = "2"
        // Add subGroup relationships to Legs
        let legSubMuscleGroups = legs.mutableSetValue(forKey: "subMuscleGroups")
        legSubMuscleGroups.add(hamstrings)
        legSubMuscleGroups.add(quads)
        legSubMuscleGroups.add(glutes)
        legSubMuscleGroups.add(calves)

        // Arms subGroups
        // Biceps
        let biceps = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        biceps.name = "Biceps"
        biceps.orderTag = "0"
        // Triceps
        let triceps = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        triceps.name = "Triceps"
        triceps.orderTag = "1"

        // Arms
        let arms = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        arms.name = "Arms"
        arms.orderTag = "3"
        // Add subGroup relationships to Arms
        let armsSubMuscleGroups = arms.mutableSetValue(forKey: "subMuscleGroups")
        armsSubMuscleGroups.add(biceps)
        armsSubMuscleGroups.add(triceps)

        // Shoulders
        let shoulders = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        shoulders.name = "Shoulders"
        shoulders.orderTag = "4"

        // Core
        let core = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        core.name = "Core"
        core.orderTag = "5"

        // Full Body
        let fullBody = MuscleGroup(entity: entity, insertInto: coreDataStack.managedObjectContext)
        fullBody.name = "Full Body"
        fullBody.orderTag = "6"

        coreDataStack.saveMainContext()

        DataManager.getExercisesDataFromFileWithSuccess { (data) in

            var json: Payload!

            do {
                json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions()) as? Payload
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

        DispatchQueue.main.async { 
            completion()
        }
    }

    func loadExercisesFromJSON(_ keyName: String, json: Payload, muscleGroup: MuscleGroup) {

        guard let entity = NSEntityDescription.entity(forEntityName: "DefaultExercise", in: coreDataStack.managedObjectContext) else {
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

            let exercise = DefaultExercise(entity: entity, insertInto: coreDataStack.managedObjectContext)
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

    func loadExerciseVolumesFromPlist(_ keyName: String, dict: NSDictionary) {
        guard let entity = NSEntityDescription.entity(forEntityName: "ExerciseVolume", in: coreDataStack.managedObjectContext), let zoneEntity = NSEntityDescription.entity(forEntityName: "TrainingZone", in: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity descriptions!")
        }

        let trainingZone = TrainingZone(entity: zoneEntity, insertInto: coreDataStack.managedObjectContext)
        trainingZone.name = keyName
        trainingZone.isActive = true
        let exerciseVolumesRelation = trainingZone.mutableSetValue(forKey: "exerciseVolumes")

        guard let exerciseVolumes = dict[keyName.lowercased()] as? [[String: AnyObject]]
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

            let exerciseVolume = ExerciseVolume(entity: entity, insertInto: coreDataStack.managedObjectContext)
            exerciseVolume.sets = sets
            exerciseVolume.reps = reps
            exerciseVolume.restTime = restTime

            exerciseVolumesRelation.add(exerciseVolume)
        }

        coreDataStack.saveMainContext()
    }

}







