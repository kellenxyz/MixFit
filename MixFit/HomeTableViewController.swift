//
//  HomeTableViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/14/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController {

    /*
    let kTableHeaderHeight: CGFloat = 150.0
    var headerView: UIView!
    */
    var coreDataStack: CoreDataStack!
    var muscleGroups = [MuscleGroup]()
    var expansionPacks: [String] = []

    @IBOutlet weak var hudGreetingLabel: UILabel!
    @IBOutlet weak var hudQuoteLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()

        self.hudQuoteLabel.text = HUDGreeting.getQuoteForGreeting()

        // Set MixFit logo in navbar
        let logo = UIImage(named: "mixfit-title-logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 24))
        imageView.image = logo
        imageView.contentMode = .ScaleAspectFit
        self.navigationItem.titleView = imageView

        // Dummy Data for tableView
//        muscleGroups = ["Back", "Chest", "Legs", "Arms", "Shoulders", "Core", "Full Body"]
        expansionPacks = ["Kettlebell", "Bodyweight"]

        /*
        // Assign storyboard headerView to headerView property
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)

        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)

        updateHeaderView()
        */

        // Set color of tableViewCell separators
        tableView.separatorColor = UIColor(colorLiteralRed: 0.88, green: 0.88, blue: 0.88, alpha: 1)

        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")

        // Remove extra emtpy tableViewCell rows after last cell
        tableView.tableFooterView = UIView()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.hudGreetingLabel.text = HUDGreeting.displayGreetingForTimeOfDay()
        reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }

    func reloadData() {
        let fetchRequest = NSFetchRequest(entityName: "MuscleGroup")
        let predicate = NSPredicate(format: "parentMuscleGroup == nil")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "orderTag", ascending: true)
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

    /*
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }

        headerView.frame = headerRect

        if tableView.contentOffset.y >= 0 {
            tableView.contentInset = UIEdgeInsetsZero
        } else {
            tableView.contentInset = UIEdgeInsets(top: min(-tableView.contentOffset.y, kTableHeaderHeight), left: 0, bottom: 0, right: 0)
        }

    }
    */

    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        updateHeaderView()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return muscleGroups.count
        case 1:
            return 1
        default:
            return muscleGroups.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MuscleGroupTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MuscleGroupCell", forIndexPath: indexPath) as! MuscleGroupTableViewCell
        let muscleGroup = muscleGroups[indexPath.row]
//        cell.muscleGroup = muscleGroup

        var cellTitle: String
        if indexPath.section == 0 {
            cell.mgCellTextLabel.text = muscleGroup.name.uppercaseString
        } else {
            cellTitle = "Kettlebell Expansion"
            cell.mgCellTextLabel.text = cellTitle.uppercaseString
        }

        if muscleGroup.subMuscleGroups?.count > 0 {
            cell.accessoryType = .DisclosureIndicator
        } else {
            cell.accessoryType = .None
        }


        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let muscleGroup = muscleGroups[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath)

        if muscleGroup.subMuscleGroups?.count > 0 {
            performSegueWithIdentifier("ShowSubMuscleGroups", sender: cell)
        } else {
            performSegueWithIdentifier("ShowExercisePageController", sender: cell)
        }

//        guard let exercises = muscleGroup.exercises,
//            let exercisesArray = Array(exercises) as? [DefaultExercise]
//            else {
//                fatalError("Oops!")
//        }
//
//        print("******************************\n\(muscleGroup.name): \(exercises.count) exercises\n")
//
//        for exercise in exercisesArray {
//            print("\(exercise.name)\n\(exercise.exerciseID)\n")
//        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
        let header = cell as! TableSectionHeader

        if section == 0 {
            header.titleLabel.text = "MUSCLE GROUPS"
        } else {
            header.titleLabel.text = "EXPANSION PACKS"
        }

        return cell
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let selectedCell = sender as? MuscleGroupTableViewCell, let selectedRowIndex = tableView.indexPathForCell(selectedCell)?.row else {
            fatalError("Sender is not a UITableViewCell or was not found in the tableView, or segue.identifier is not correct")
        }
        let muscleGroup = muscleGroups[selectedRowIndex]
        if segue.identifier == "ShowExercisePageController" {
            let navController = segue.destinationViewController as? UINavigationController
            let destinationViewController = navController?.topViewController as? ExercisePageViewController
            destinationViewController?.mixlistName = muscleGroup.name
//            destinationViewController?.coreDataStack = self.coreDataStack
            if let exercises = muscleGroup.exercises {
                destinationViewController?.pageCount = exercises.count
                let exercisesArray = Array(exercises) as! [Exercise]
                destinationViewController?.exercises = exercisesArray.shuffle()
            }
        } else if segue.identifier == "ShowSubMuscleGroups" {
            // Segue to subMuscleGroup view controller
            let destinationViewController = segue.destinationViewController as? SubMuscleGroupsTableViewController
            destinationViewController?.muscleGroup = muscleGroup
        }
    }

}









