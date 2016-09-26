//
//  ExerciseDetailViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 8/1/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

class ExerciseDetailViewController: UIViewController {

    var coreDataStack = CoreDataStack.sharedInstance
    var exercise: Exercise!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var muscleGroupsTargetedLabel: UILabel!
    @IBOutlet weak var trainersNotesLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "EXERCISE"

        if (exercise == exercise as? UserCreatedExercise) {
            let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ExerciseDetailViewController.onOptionsButtonPressed))
            editItem.tintColor = UIColor.white
            navigationItem.rightBarButtonItem = editItem
        }

        // Set labels
        exerciseNameLabel.text = exercise.name.uppercased()
        muscleGroupsTargetedLabel.text = exercise.targetedMuscles
        trainersNotesLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."


        scrollView.contentSize.width = view.frame.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func onOptionsButtonPressed() {
        let actionSheet = UIAlertController(title: "Exercise Options", message: nil, preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete Exercise", style: .destructive) { (action) in
            let alertController = UIAlertController(title: "Delete \"\(self.exercise.name)\"?", message: "Are you sure you wish to delete this exercise? This action cannot be undone.", preferredStyle: .alert)
            let cancelDelete = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                // delete mixlist
                self.performSegue(withIdentifier: "DeleteExerciseFromDataSource", sender: self)
            })
            alertController.addAction(cancelDelete)
            alertController.addAction(delete)
            self.present(alertController, animated: true, completion: {
                // take any further actions required here
            })
        }
        let renameAction = UIAlertAction(title: "Rename", style: .default) { (action) in
            // Rename view controller
        }
        let editImageAction = UIAlertAction(title: "Edit Exercise Image", style: .default) { (action) in
            // Choose new image
        }
        let changeMuscleGroupAction = UIAlertAction(title: "Change Muscle Group", style: .default) { (action) in
            guard let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseEditNavigationController") as? UINavigationController, let muscleGroupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseMuscleGroupViewController") as? ExerciseMuscleGroupViewController else {
                fatalError("Could not instantiate ExerciseMuscleGroupViewController")
            }
            navController.setViewControllers([muscleGroupVC], animated: true)
            if let exercise = self.exercise as? UserCreatedExercise {
                muscleGroupVC.existingExercise = exercise
            }
            self.present(navController, animated: true, completion: {
                //
            })
        }

        actionSheet.addAction(renameAction)
        actionSheet.addAction(editImageAction)
        actionSheet.addAction(changeMuscleGroupAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)

        self.present(actionSheet, animated: true, completion: nil)
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
