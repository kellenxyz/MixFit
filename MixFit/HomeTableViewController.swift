//
//  HomeTableViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/14/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    /*
    let kTableHeaderHeight: CGFloat = 150.0
    var headerView: UIView!
    */
    var muscleGroups: [String] = []
    var expansionPacks: [String] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()

        // Set MixFit logo in navbar
        let logo = UIImage(named: "mixfit-title-logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 24))
        imageView.image = logo
        imageView.contentMode = .ScaleAspectFit
        self.navigationItem.titleView = imageView

        // Dummy Data for tableView
        muscleGroups = ["Back", "Chest", "Legs", "Arms", "Shoulders", "Core", "Full Body"]
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

        tableView.separatorColor = UIColor(colorLiteralRed: 0.92, green: 0.92, blue: 0.92, alpha: 1)

        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")

        // Remove extra emtpy tableViewCell rows after last cell
        tableView.tableFooterView = UIView()

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

        var cellTitle: String
        if indexPath.section == 0 {
            cellTitle = muscleGroups[indexPath.row]
            cell.mgCellTextLabel.text = cellTitle.uppercaseString
        } else {
            cellTitle = "Kettlebell Expansion"
            cell.mgCellTextLabel.text = cellTitle.uppercaseString
        }

        if cellTitle == "Legs" || cellTitle == "Arms" {
            cell.accessoryType = .DisclosureIndicator
        } else {
            cell.accessoryType = .None
        }


        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MuscleGroupTableViewCell {
            if cell.mgCellTextLabel.text == "LEGS" || cell.mgCellTextLabel.text == "ARMS" {
                performSegueWithIdentifier("ShowSubMuscleGroups", sender: self)
            } else {
                performSegueWithIdentifier("ShowExercisePageController", sender: self)
            }
        }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
