//
//  ExerciseMuscleGroupViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 8/6/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

class ExerciseMuscleGroupViewController: UIViewController {

    var coreDataStack = CoreDataStack.sharedInstance
    var muscleGroups = [MuscleGroup]()
    var selectedIndex: NSIndexPath?
    var selectedMuscleGroup: MuscleGroup?
    var exercise: UserCreatedExercise?
    var exerciseName: String!
    var existingExercise: UserCreatedExercise?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        if existingExercise != nil {
            title = "CHANGE MUSCLE GROUP"
        } else {
            title = "NEW EXERCISE"
        }

        if let exercise = exercise {
            print(exercise)
        }

        if selectedIndex == nil {
            nextBarButtonItem.enabled = false
        } else {
            nextBarButtonItem.enabled = true
        }

        // Set color of tableViewCell separators
        tableView.separatorColor = UIColor(colorLiteralRed: 0.88, green: 0.88, blue: 0.88, alpha: 1)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()


    }

    func reloadData() {
        let fetchRequest = NSFetchRequest(entityName: "MuscleGroup")
//        let predicate = NSPredicate(format: "parentMuscleGroup == nil")
//        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]

        do {
            if let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [MuscleGroup] {
                muscleGroups = results
            }
        } catch {
            fatalError("Error fetching data! \(error)")
        }

        tableView.reloadData()
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as? ExerciseImageSelectViewController
        destinationViewController?.exercise = self.exercise
    }


}

extension ExerciseMuscleGroupViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return muscleGroups.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MuscleGroupCell", forIndexPath: indexPath)

        let muscleGroup = muscleGroups[indexPath.row]
        let cellString: String = muscleGroup.name
        cell.textLabel?.text = cellString

        if selectedIndex == nil {
            if let exercise = exercise {
                cell.accessoryType = (exercise.muscleGroup == muscleGroup) ? .Checkmark : .None
                if cell.accessoryType == .Checkmark {
                    selectedIndex = indexPath
                    self.nextBarButtonItem.enabled = true
                }
            } else {
                //
            }
        } else {
            cell.accessoryType = (indexPath == selectedIndex) ? .Checkmark : .None
        }

        if cell.accessoryType == .Checkmark {
            cell.tintColor = UIColor(colorLiteralRed: 203.0/255.0, green: 51.0/255.0, blue: 0.0, alpha: 1.0)
            cell.backgroundColor = UIColor(colorLiteralRed: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
            cell.textLabel?.textColor = UIColor(colorLiteralRed: 203.0/255.0, green: 51.0/255.0, blue: 0.0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
            cell.textLabel?.textColor = UIColor(colorLiteralRed: 0.098, green: 0.098, blue: 0.098, alpha: 1.0)
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let prevSelectedIndex = selectedIndex
        selectedIndex = indexPath
        selectedMuscleGroup = muscleGroups[indexPath.row]

        if let exercise = self.exercise {
//            let exerciseMuscleGroup = exercise.mutableSetValueForKey("muscleGroup")
            if let muscleGroup = selectedMuscleGroup {
                exercise.setValue(muscleGroup, forKey: "muscleGroup")
            }
            coreDataStack.saveMainContext()
            print(exercise.muscleGroup)
        }

        if let previous = prevSelectedIndex {
            tableView.reloadRowsAtIndexPaths([previous, indexPath], withRowAnimation: .Fade)
        } else {
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }

        if selectedIndex == nil {
            nextBarButtonItem.enabled = false
        } else {
            nextBarButtonItem.enabled = true
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}







