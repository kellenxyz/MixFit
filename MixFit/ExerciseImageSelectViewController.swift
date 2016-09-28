//
//  ExerciseImageSelectViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 8/6/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

protocol ExerciseCreationDelegate {
    func didCreateNewExercise(_ exercise: UserCreatedExercise)
}

class ExerciseImageSelectViewController: UIViewController {

    var coreDataStack = CoreDataStack.sharedInstance
    var exercise: UserCreatedExercise?
    var existingExercise: UserCreatedExercise?
    var saveButton: UIBarButtonItem!

    var delegate: ExerciseCreationDelegate?

    var exerciseName: String!
    var muscleGroup: MuscleGroup!

    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(ExerciseImageSelectViewController.onSaveButtonPressed(_:)))
        saveButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold), NSForegroundColorAttributeName: ColorWheel.leadColor()], for: .normal)
        navigationItem.rightBarButtonItem = saveButton

//        if let exercise = exercise {
//            print(exercise)
//        }

        if existingExercise != nil {
            title = "EDIT IMAGE"
        } else {
            title = "NEW EXERCISE"
        }

        print(exerciseName)
        print(muscleGroup)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions
    
    @IBAction func onSaveButtonPressed(_ sender: UIBarButtonItem) {

        guard let entity = NSEntityDescription.entity(forEntityName: "UserCreatedExercise", in: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity descriptions!")
        }

        let newExercise = UserCreatedExercise(entity: entity, insertInto: coreDataStack.managedObjectContext)
        newExercise.name = self.exerciseName
        newExercise.muscleGroup = self.muscleGroup
        newExercise.isFavorite = false
        newExercise.targetedMuscleGroups = self.muscleGroup.name

        self.coreDataStack.saveMainContext()

        self.dismiss(animated: true) { 
            if let delegate = self.delegate {
                delegate.didCreateNewExercise(newExercise)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
