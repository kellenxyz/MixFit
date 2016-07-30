//
//  SubMuscleGroupsTableViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/14/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

class SubMuscleGroupsTableViewController: UITableViewController {

    var coreDataStack = CoreDataStack.sharedInstance
    var muscleGroup: MuscleGroup!
    var muscleGroups = [MuscleGroup]()
    var allExercises = [Exercise]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = muscleGroup.name.uppercaseString

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // Set color of tableViewCell separators
        tableView.separatorColor = UIColor(colorLiteralRed: 0.88, green: 0.88, blue: 0.88, alpha: 1)

        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()
    }

    func reloadData() {
        let fetchRequest = NSFetchRequest(entityName: "MuscleGroup")
        let predicate = NSPredicate(format: "parentMuscleGroup == %@", self.muscleGroup)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "orderTag", ascending: true)
        ]

        do {
            if let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [MuscleGroup] {
                muscleGroups = results

                for muscleGroup in muscleGroups {
                    if let exercises = muscleGroup.exercises {
                        let exercisesArray = Array(exercises) as! [Exercise]
                        allExercises.appendContentsOf(exercisesArray)
                    }
                }
            }
        } catch {
            fatalError("Error fetching data! \(error)")
        }

        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count = 0

        switch section {
        case 0:
            count = 1
        default:
            count = muscleGroups.count
        }

        return count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SubMuscleGroupCell", forIndexPath: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = "Mix All \(muscleGroup.name)".uppercaseString
        } else {
            let muscleGroup = self.muscleGroups[indexPath.row]
            let cellText: String = muscleGroup.name
            cell.textLabel?.text = cellText.uppercaseString
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.cellForRowAtIndexPath(indexPath)

        performSegueWithIdentifier("ShowExercisePageController", sender: cell)

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let selectedCell = sender as? UITableViewCell, let selectedRowIndexPath = tableView.indexPathForCell(selectedCell) else {
            fatalError("Sender is not a UITableViewCell or was not found in the tableView, or segue.identifier is not correct")
        }
        let muscleGroup = muscleGroups[selectedRowIndexPath.row]
        if segue.identifier == "ShowExercisePageController" {
            let navController = segue.destinationViewController as? UINavigationController
            let destinationViewController = navController?.topViewController as? ExercisePageViewController
            if selectedRowIndexPath.section == 0 {
                destinationViewController?.mixlistName = "All \(self.muscleGroup.name)".uppercaseString
                destinationViewController?.pageCount = allExercises.count
                destinationViewController?.exercises = allExercises.shuffle()
            } else {
                destinationViewController?.mixlistName = muscleGroup.name
                if let exercises = muscleGroup.exercises {
                    destinationViewController?.pageCount = exercises.count
                    let exercisesArray = Array(exercises) as! [Exercise]
                    destinationViewController?.exercises = exercisesArray.shuffle()
                }
            }
        }
    }


}
