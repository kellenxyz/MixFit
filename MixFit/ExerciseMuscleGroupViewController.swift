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
    var muscleGroups: [MuscleGroup]?
    var selectedIndex: IndexPath?
    var selectedMuscleGroup: MuscleGroup?
    var exercise: UserCreatedExercise?
    var exerciseName: String?
    var existingExercise: UserCreatedExercise?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        if existingExercise != nil {
            // Create and add close button
            title = "CHANGE MUSCLE GROUP"
            let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ExerciseMuscleGroupViewController.dismissWithoutSaving))
            navigationItem.leftBarButtonItem = closeBarButtonItem
            // Create and add save button
            let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(ExerciseMuscleGroupViewController.onSaveButtonPressed))
            saveButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold), NSForegroundColorAttributeName: ColorWheel.leadColor()], for: .normal)
            navigationItem.rightBarButtonItem = saveButton
        } else {
            title = "NEW EXERCISE"
            navigationItem.rightBarButtonItem = self.nextBarButtonItem
        }

        if selectedIndex == nil {
            nextBarButtonItem?.isEnabled = false
        } else {
            nextBarButtonItem?.isEnabled = true
        }

        // Set color of tableViewCell separators
        tableView.separatorColor = UIColor(colorLiteralRed: 0.88, green: 0.88, blue: 0.88, alpha: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()


    }

    func reloadData() {
        let fetchRequest: NSFetchRequest<MuscleGroup> = MuscleGroup.fetchRequest()
//        let predicate = NSPredicate(format: "subMuscleGroups.count == 0")
//        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]

        do {
            muscleGroups = try coreDataStack.managedObjectContext.fetch(fetchRequest)

        } catch {
            fatalError("Error fetching data! \(error)")
        }

        tableView.reloadData()
    }

    func dismissWithoutSaving() {
        self.dismiss(animated: true) { 
            //
        }
    }

    func onSaveButtonPressed() {
        // Save data to MOC
        if let selectedMuscleGroup = self.selectedMuscleGroup {
            self.existingExercise?.muscleGroup = selectedMuscleGroup
            coreDataStack.saveMainContext()
        }
        self.dismiss(animated: true) { 
            //
        }
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? ExerciseImageSelectViewController
        destinationViewController?.exerciseName = self.exerciseName ?? "Unknown"
        guard let muscleGroup = self.selectedMuscleGroup else {
            fatalError("Did not set muscle group before segue")
        }
        destinationViewController?.muscleGroup = muscleGroup
    }


}

extension ExerciseMuscleGroupViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let muscleGroups = self.muscleGroups {
            return muscleGroups.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MuscleGroupCell", for: indexPath)

        if let muscleGroups = self.muscleGroups {
            let muscleGroup = muscleGroups[(indexPath as NSIndexPath).row]
            let cellString: String = muscleGroup.name
            cell.textLabel?.text = cellString

            if selectedIndex == nil {
                if let exercise = self.existingExercise {
                    cell.accessoryType = (exercise.muscleGroup == muscleGroup) ? .checkmark : .none
                    if cell.accessoryType == .checkmark {
                        selectedIndex = indexPath
                        self.nextBarButtonItem?.isEnabled = true
                    }
                } else {
                    //
                }
            } else {
                cell.accessoryType = (indexPath == selectedIndex) ? .checkmark : .none
            }

            if cell.accessoryType == .checkmark {
                cell.tintColor = ColorWheel.redColor()
                cell.backgroundColor = UIColor(colorLiteralRed: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
                cell.textLabel?.textColor = ColorWheel.redColor()
            } else {
                cell.backgroundColor = UIColor.white
                cell.textLabel?.textColor = ColorWheel.leadColor()
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let prevSelectedIndex = selectedIndex
        selectedIndex = indexPath
        if let muscleGroups = self.muscleGroups {
            selectedMuscleGroup = muscleGroups[(indexPath as NSIndexPath).row]
        }

        if let previous = prevSelectedIndex {
            tableView.reloadRows(at: [previous, indexPath], with: .fade)
        } else {
            tableView.reloadRows(at: [indexPath], with: .fade)
        }

        if selectedIndex == nil {
            nextBarButtonItem?.isEnabled = false
        } else {
            nextBarButtonItem?.isEnabled = true
        }

//        tableView.deselectRow(at: indexPath, animated: true)
    }
}







