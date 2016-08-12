//
//  ExerciseImageSelectViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 8/6/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit

class ExerciseImageSelectViewController: UIViewController {

    var exercise: UserCreatedExercise?
    var existingExercise: UserCreatedExercise?

    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let exercise = exercise {
            print(exercise)
        }

        if existingExercise != nil {
            title = "EDIT IMAGE"
        } else {
            title = "NEW EXERCISE"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions
    
    @IBAction func onSaveButtonPressed(sender: UIBarButtonItem) {

        self.dismissViewControllerAnimated(true, completion: nil)
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
