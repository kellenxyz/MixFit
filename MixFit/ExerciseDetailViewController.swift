//
//  ExerciseDetailViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 8/1/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit

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

        exerciseNameLabel.text = exercise.name.uppercaseString
        muscleGroupsTargetedLabel.text = exercise.targetedMuscleGroups
        trainersNotesLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."


        scrollView.contentSize.width = view.frame.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
