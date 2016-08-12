//
//  ExerciseNameViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 8/6/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

class ExerciseNameViewController: UIViewController {

    var coreDataStack = CoreDataStack.sharedInstance
    var newExercise: UserCreatedExercise?
    var existingExercise: UserCreatedExercise?
    var exerciseName: String = ""
    var newTitle: String?
    
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var exerciseNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = newTitle ?? "New Exercise".uppercaseString

        if let exercise = newExercise {
            exerciseName = exercise.name
            exerciseNameTextField.text = exerciseName
        }

        if exerciseName == "" {
            nextBarButtonItem.enabled = false
        } else {
            nextBarButtonItem.enabled = true
        }

        exerciseNameTextField.becomeFirstResponder()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if newExercise != nil {
            print(newExercise)
        }
    }


    // MARK: - IBActions

    @IBAction func onCancelButtonPressed(sender: UIBarButtonItem) {

        if let exercise = newExercise {
            print("Deleted \(exercise.name)")
            coreDataStack.managedObjectContext.deleteObject(exercise)
            coreDataStack.saveMainContext()
        }

        exerciseNameTextField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onNextButtonPressed(sender: UIBarButtonItem) {


    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if newExercise == nil {
//            let holderMuscleGroup = MuscleGroup()

            guard let entity = NSEntityDescription.entityForName("UserCreatedExercise", inManagedObjectContext: coreDataStack.managedObjectContext) else {
                fatalError("Could not find entity descriptions!")
            }
            let exercise = UserCreatedExercise(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
            if let text = exerciseNameTextField.text {
                exercise.name = text
            }
//            let muscleGroupRelation = exercise.mutableSetValueForKey("muscleGroup")
//            muscleGroupRelation.addObject(holderMuscleGroup)
            exercise.isFavorite = false

            coreDataStack.saveMainContext()

            newExercise = exercise
        }
        
        let destinationViewController = segue.destinationViewController as? ExerciseMuscleGroupViewController
        destinationViewController?.exercise = newExercise
    }


}

extension ExerciseNameViewController: UITextFieldDelegate {

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 34
        return (exerciseNameTextField?.text?.utf16.count ?? 0) + string.utf16.count - range.length <= maxLength
    }

    @IBAction func textFieldTextDidChange(sender: UITextField) {
        if let name = exerciseNameTextField.text {
            exerciseName = name
        }

        if exerciseName == "" {
            nextBarButtonItem.enabled = false
        } else {
            nextBarButtonItem.enabled = true
        }

    }
    
}











