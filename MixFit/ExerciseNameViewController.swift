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

    var existingExercise: UserCreatedExercise?
    var exerciseName: String = ""
    var newTitle: String?
    
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var exerciseNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = newTitle ?? "New Exercise".uppercased()

        if exerciseName == "" {
            nextBarButtonItem.isEnabled = false
        } else {
            nextBarButtonItem.isEnabled = true
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

        if exerciseName == "" {
            nextBarButtonItem.isEnabled = false
        } else {
            nextBarButtonItem.isEnabled = true
        }

    }
    
}











