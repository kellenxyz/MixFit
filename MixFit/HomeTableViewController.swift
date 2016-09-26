//
//  HomeTableViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/14/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class HomeTableViewController: UITableViewController {


    let kTableHeaderHeight: CGFloat = 150.0
    var headerView: UIView!

    var coreDataStack = CoreDataStack.sharedInstance
    var muscleGroups = [MuscleGroup]()
    var expansionPacks: [String] = []

    @IBOutlet weak var hudGreetingLabel: UILabel!
    @IBOutlet weak var hudQuoteLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationController?.hidesBarsOnSwipe = true

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        self.hudQuoteLabel.text = HUDGreeting.getQuoteForGreeting()

        // Set MixFit logo in navbar
        let logo = UIImage(named: "mixfit-title-logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 24))
        imageView.image = logo
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView

        // Dummy data
        expansionPacks = ["Kettlebell", "Bodyweight"]


        // Assign storyboard headerView to headerView property
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)

        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)

        updateHeaderView()


        // Set color of tableViewCell separators
        tableView.separatorColor = UIColor(colorLiteralRed: 0.88, green: 0.88, blue: 0.88, alpha: 1)

        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")

        // Remove extra emtpy tableViewCell rows after last cell
        tableView.tableFooterView = UIView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.hudGreetingLabel.text = HUDGreeting.displayGreetingForTimeOfDay()
        reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    func reloadData() {
        let fetchRequest = NSFetchRequest<MuscleGroup>(entityName: "MuscleGroup")
        let predicate = NSPredicate(format: "parentMuscleGroup == nil")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "orderTag", ascending: true)
        ]

        do {
            let results = try coreDataStack.managedObjectContext.fetch(fetchRequest)
            muscleGroups = results

        } catch {
            fatalError("Error fetching data! \(error)")
        }

        tableView.reloadData()
    }


    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }

        headerView.frame = headerRect



    }


    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

//        if tableView.contentOffset.y >= 0 {
//            tableView.contentInset = UIEdgeInsetsZero
//        } else {
//            tableView.contentInset = UIEdgeInsets(top: min(-tableView.contentOffset.y, kTableHeaderHeight), left: 0, bottom: 0, right: 0)
//        }

        updateHeaderView()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return muscleGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MuscleGroupTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MuscleGroupCell", for: indexPath) as! MuscleGroupTableViewCell

        let muscleGroup = muscleGroups[(indexPath as NSIndexPath).row]

        cell.mgCellTextLabel.text = muscleGroup.name.uppercased()

        if muscleGroup.subMuscleGroups?.count > 0 {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let muscleGroup = muscleGroups[(indexPath as NSIndexPath).row]
        let cell = tableView.cellForRow(at: indexPath)

        if muscleGroup.subMuscleGroups?.count > 0 {
            performSegue(withIdentifier: "ShowSubMuscleGroups", sender: cell)
        } else {
            performSegue(withIdentifier: "ShowExercisePageController", sender: cell)
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

        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
        let header = cell as! TableSectionHeader

        header.titleLabel.text = "MUSCLE GROUPS"

        return cell
    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    */

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedCell = sender as? MuscleGroupTableViewCell, let selectedRowIndex = (tableView.indexPath(for: selectedCell) as NSIndexPath?)?.row else {
            fatalError("Sender is not a UITableViewCell or was not found in the tableView, or segue.identifier is not correct")
        }
        let muscleGroup = muscleGroups[selectedRowIndex]
        if segue.identifier == "ShowExercisePageController" {
            let navController = segue.destination as? UINavigationController
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
            let destinationViewController = segue.destination as? SubMuscleGroupsTableViewController
            destinationViewController?.muscleGroup = muscleGroup
        }
    }

}









