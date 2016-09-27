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
    lazy var coreDataStack = CoreDataStack.sharedInstance


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        let fontAttributes = [NSFontAttributeName:  font]
        UIBarButtonItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)



//        if let font = UIFont(name: "RobotoCondensed-Bold", size: 16) {
//            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
//        }

        UITabBar.appearance().tintColor = UIColor(colorLiteralRed: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0)

        let fetchRequest = NSFetchRequest<MuscleGroup>(entityName: "MuscleGroup")
        do {
            let results = try coreDataStack.managedObjectContext.fetch(fetchRequest)
            if results.count == 0 {
                preloadData()
            } else {
                updateData()
            }
        } catch {
            fatalError("Error fetching data!")
        }

        /*
        let fetchRequestForTrainingZones = NSFetchRequest(entityName: "TrainingZone")
        do {
            let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequestForTrainingZones)
            if results.count == 0 {
                addDefaultData()
            }
        } catch {
            fatalError("Error fetching training zone data!")
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
        */

        return true
    }

    func preloadData() {
        let preloadDataManager = PreloadDataManager()
        preloadDataManager.coreDataStack = self.coreDataStack
        preloadDataManager.preloadAppData()
    }

    func updateData() {
        let updateDataManager = UpdateDataManager()
        updateDataManager.coreDataStack = self.coreDataStack
        updateDataManager.updateAppData()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataStack.saveMainContext()
    }

}

