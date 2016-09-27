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
    var existingExercise: UserCreatedExercise?
    var exerciseName: String = ""
    var newTitle: String?

    var saveButton: UIBarButtonItem?
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem?
    @IBOutlet weak var exerciseNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = newTitle ?? "New Exercise".uppercased()

        if existingExercise != nil {
            // Create and add close button
            title = "RENAME EXERCISE"
//            let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ExerciseMuscleGroupViewController.dismissWithoutSaving))
//            navigationItem.leftBarButtonItem = closeBarButtonItem
            // Create and add save button
            saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(ExerciseNameViewController.onSaveButtonPressed))
            saveButton?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold), NSForegroundColorAttributeName: ColorWheel.leadColor()], for: .normal)
            navigationItem.rightBarButtonItem = saveButton

            exerciseName = existingExercise!.name
            exerciseNameTextField.text = existingExercise!.name
        } else {
            title = "NEW EXERCISE"
            navigationItem.rightBarButtonItem = self.nextBarButtonItem

            if exerciseName == "" {
                nextBarButtonItem?.isEnabled = false
            } else {
                nextBarButtonItem?.isEnabled = true
            }
        }

        exerciseNameTextField.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print(exerciseName)

    }


    // MARK: - IBActions

    @IBAction func onCancelButtonPressed(_ sender: UIBarButtonItem) {

        exerciseNameTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onNextButtonPressed(_ sender: UIBarButtonItem) {


    }

    func onSaveButtonPressed() {
        self.existingExercise?.name = exerciseName
        coreDataStack.saveMainContext()

        exerciseNameTextField.resignFirstResponder()
        self.dismiss(animated: true) {
            //
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination as? ExerciseMuscleGroupViewController
        destinationViewController?.exerciseName = self.exerciseName
    }


}

extension ExerciseNameViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 34
        return (exerciseNameTextField?.text?.utf16.count ?? 0) + string.utf16.count - range.length <= maxLength
    }

    @IBAction func textFieldTextDidChange(_ sender: UITextField) {
        if let name = exerciseNameTextField.text {
            exerciseName = name
        }

        if existingExercise != nil {
            if exerciseName == "" {
                saveButton?.isEnabled = false
            } else {
                saveButton?.isEnabled = true
            }
        } else {
            if exerciseName == "" {
                nextBarButtonItem?.isEnabled = false
            } else {
                nextBarButtonItem?.isEnabled = true
            }
        }

    }
    
}











