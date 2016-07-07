//
//  AppDelegate.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/7/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        if let font = UIFont(name: "RobotoCondensed-Bold", size: 16) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
        }

        UITabBar.appearance().tintColor = UIColor(colorLiteralRed: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0)

        let fetchRequest = NSFetchRequest(entityName: "MuscleGroup")
        do {
            let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count == 0 {
                preloadData()
            }
        } catch {
            fatalError("Error fetching data!")
        }

        if let tab = window?.rootViewController as? UITabBarController {
            for child in tab.viewControllers ?? [] {
                if let child = child as? UINavigationController, top = child.topViewController {
                    if top.respondsToSelector(Selector("setCoreDataStack:")) {
                        top.performSelector(Selector("setCoreDataStack:"), withObject: coreDataStack)
                    }
                }
            }
        }

        return true
    }

    func addDefaultData() {
        // Add default exercise and mixlist data
    }

    func preloadData() {
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

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataStack.saveMainContext()
    }

}

