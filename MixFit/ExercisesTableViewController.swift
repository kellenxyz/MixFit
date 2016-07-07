//
//  ExercisesTableViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/14/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

class ExercisesTableViewController: UITableViewController {

    // #warning use fetchResultsController for this page

    var coreDataStack: CoreDataStack!
    var muscleGroups = [MuscleGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // Change color of cell separators
        tableView.separatorColor = UIColor(colorLiteralRed: 0.88, green: 0.88, blue: 0.88, alpha: 1)

        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()
    }

    func reloadData() {
        let fetchRequest = NSFetchRequest(entityName: "MuscleGroup")
        let predicate = NSPredicate(format: "name != %@ && name != %@", "Arms", "Legs")
        fetchRequest.predicate = predicate
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return muscleGroups.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let muscleGroup = muscleGroups[section]
        if let count = muscleGroup.exercises?.count {
            return count
        } else {
            return 0
        }

    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let muscleGroup = muscleGroups[section]
        return muscleGroup.name
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell", forIndexPath: indexPath)

        let muscleGroup = muscleGroups[indexPath.section]

        let fetchRequest = NSFetchRequest(entityName: "Exercise")
        let predicate = NSPredicate(format: "muscleGroup == %@", muscleGroup)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]

        do {
            if let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [Exercise] {
                let exercise = results[indexPath.row]
                cell.textLabel?.text = exercise.name
            }
        } catch {
            fatalError("Error fetching data! \(error)")
        }

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let muscleGroup = muscleGroups[section]

        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
        let header = cell as! TableSectionHeader
        header.titleLabel.text = muscleGroup.name.uppercaseString

        return cell
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
