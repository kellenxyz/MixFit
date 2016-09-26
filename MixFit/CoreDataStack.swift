//
//  CoreDataStack.swift
//  MixFit
//
//  Created by Kellen Pierson on 7/4/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {

    class var sharedInstance: CoreDataStack {
        struct Singleton {
            static let instance = CoreDataStack()
        }
        return Singleton.instance
    }

    static let moduleName = "MixFit"

    func saveMainContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Error saving main managed object context! \(error)")
            }
        }
    }

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var applicationsDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let persistentStoreURL = self.applicationsDocumentsDirectory.appendingPathComponent("\(moduleName).sqlite")

        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                       configurationName: nil,
                                                       at: persistentStoreURL,
                                                       options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch {
            fatalError("Persistent store error! \(error)")
        }

        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

        managedObjectContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)

        return managedObjectContext
    }()
}
