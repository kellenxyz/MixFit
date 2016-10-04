//
//  UpdateDataManager.swift
//  MixFit
//
//  Created by Kellen Pierson on 9/27/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import Foundation
import CoreData

class UpdateDataManager {

    var coreDataStack: CoreDataStack!
    var fetchedExercises = [DefaultExercise]()
    var fetchedMuscleGroups = [MuscleGroup]()
    var exerciseIDSet = Set<String>()

    /// Parses exercises.json file and compares its contents to existing DefaultExercise objects. DefaultExercise objects that need updates are updated.
    /// JSON objects that don't yet exist in the MOC are created and added to the MOC as DefaultExercise objects.
    func updateAppData() {
        updateExerciseAndMuscleGroupData { 
            print("Updated exercises")
        }
    }

    func updateExerciseAndMuscleGroupData(_ completion: @escaping () -> Void) {

        let fetchRequest = NSFetchRequest<MuscleGroup>(entityName: "MuscleGroup")
        let predicate = NSPredicate(format: "name != \"Legs\" && name != \"Arms\"")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]

        do {
            fetchedMuscleGroups = try coreDataStack.managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalError("Error fetching data!")
        }

        for muscleGroup in fetchedMuscleGroups {
            print(muscleGroup.name)
        }

        DataManager.getExercisesDataFromFileWithSuccess { (data) in

            var json: Payload!

            do {
                json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions()) as? Payload
            } catch {
                print(error)
                fatalError("Error paring JSON file!")
            }

            for muscleGroup in self.fetchedMuscleGroups {
                self.loadExercisesFromJSON(muscleGroup.name.lowercased(), json: json, muscleGroup: muscleGroup)
            }
        }

        DispatchQueue.main.async {
            completion()
        }
    }

    /**
     Deserializes JSON data that is passed in and runs checks against existing exercise objects, by comparing their exerciseIDs, to see if any existing DefaultExercise needs to have its data updated. 
     If it encounters a JSON exercise object that has not yet been added to the MOC, it creates a new exercise object.
    */
    func loadExercisesFromJSON(_ keyName: String, json: Payload, muscleGroup: MuscleGroup) {

        guard let entity = NSEntityDescription.entity(forEntityName: "DefaultExercise", in: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity descriptions!")
        }

        guard let exercises = json[keyName] as? [Payload]
            else {
                fatalError("Error parsing JSON file!")
        }

        let fetchRequest = NSFetchRequest<DefaultExercise>(entityName: "DefaultExercise")

        do {
            fetchedExercises = try coreDataStack.managedObjectContext.fetch(fetchRequest)

        } catch {
            fatalError("Error fetching data! \(error)")
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

            for exercise in fetchedExercises {
                // Build set of existing exercise IDs to compare against
                if let id = exercise.exerciseID {
                    exerciseIDSet.insert(id)
                }
                // Update exercise data if it needs it
                if exercise.exerciseID == exerciseID {
                    if exercise.name != name {
                        exercise.name = name
                    }
                    if exercise.imageName != imageName {
                        exercise.imageName = imageName
                    }
                    if exercise.detailDescription != detailDescription {
                        exercise.detailDescription = detailDescription
                    }
                    if exercise.targetedMuscleGroups != targetedMuscleGroups {
                        exercise.targetedMuscleGroups = targetedMuscleGroups
                    }
                }
            }

            // Create new exercise object if it doesn't yet exist
            if !exerciseIDSet.contains(exerciseID) {
                let exercise = DefaultExercise(entity: entity, insertInto: coreDataStack.managedObjectContext)
                exercise.exerciseID = exerciseID
                exercise.name = name
                exercise.isFavorite = false
                exercise.imageName = imageName
                exercise.detailDescription = detailDescription
                exercise.targetedMuscleGroups = targetedMuscleGroups
                exercise.setValue(muscleGroup, forKey: "muscleGroup")
            }
        }

        coreDataStack.saveMainContext()
    }
}
