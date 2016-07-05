//
//  Exercise+CoreDataProperties.swift
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

extension Exercise {

    @NSManaged var detailDescription: String?
    @NSManaged var isFavorite: NSNumber
    @NSManaged var name: String
    @NSManaged var targetedMuscleGroups: String?
    @NSManaged var muscleGroup: NSManagedObject
    @NSManaged var userCreatedMixlists: NSSet?

}
