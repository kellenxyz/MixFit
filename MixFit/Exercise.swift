//
//  Exercise.swift
//  MixFit
//
//  Created by Kellen Pierson on 7/5/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import Foundation
import CoreData


class Exercise: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    var targetedMuscles: String {
        if self.targetedMuscleGroups == nil {
            return "None specified for this exercise."
        } else {
            return self.targetedMuscleGroups!
        }
    }

}
