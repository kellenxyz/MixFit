//
//  ExerciseVolume.swift
//  MixFit
//
//  Created by Kellen Pierson on 7/23/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import Foundation
import CoreData


class ExerciseVolume: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    var setsAndReps: String {
        return "\(self.sets) x \(self.reps)"
//        if self.sets == "1" {
//            return "\(self.sets) set of \(self.reps) reps"
//        } else if self.reps == "1" {
//            return "\(self.sets) sets of \(self.reps) rep"
//        } else if self.sets == "1" && self.reps == "1" {
//            return "\(self.sets) set of \(self.reps) rep"
//        } else {
//            return "\(self.sets) sets of \(self.reps) reps"
//        }
    }

    var rest: String {
        return "\(self.restTime) rest"
    }
    
}
