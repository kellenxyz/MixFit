//
//  MuscleGroup+CoreDataProperties.swift
//  MixFit
//
//  Created by Kellen Pierson on 7/5/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MuscleGroup {

    @NSManaged var exercises: NSSet?
    @NSManaged var parentMuscleGroup: MuscleGroup?
    @NSManaged var subMuscleGroups: NSSet?
    @NSManaged var orderTag: String?

}

extension MuscleGroup {
    @nonobjc class func fetchRequest() -> NSFetchRequest<MuscleGroup> {
        return NSFetchRequest<MuscleGroup>(entityName: "MuscleGroup");
    }

    @NSManaged var timeStamp: NSDate?
}
