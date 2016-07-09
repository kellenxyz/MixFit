//
//  MixlistsTableViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/14/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

class MixlistsTableViewController: UITableViewController {

    var coreDataStack: CoreDataStack!

    var mixlists: [UserCreatedMixlist] = [UserCreatedMixlist]()
    var favMuscleGroups: [MuscleGroup] = [MuscleGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorColor = UIColor(colorLiteralRed: 0.92, green: 0.92, blue: 0.92, alpha: 1)

        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")

//        loadFavoritesData()

        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let font = UIFont(name: "RobotoCondensed-Bold", size: 16) {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        }

        reloadData()
    }

    func reloadData() {
        let fetchRequest = NSFetchRequest(entityName: "UserCreatedMixlist")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]

        do {
            if let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [UserCreatedMixlist] {
                mixlists = results
            }
        } catch {
            fatalError("Error fetching data! \(error)")
        }

        tableView.reloadData()
    }

    func loadFavoritesData() {
        let fetchRequest = NSFetchRequest(entityName: "MuscleGroup")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]

        do {
            if let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [MuscleGroup] {
                favMuscleGroups = results
            }
        } catch {
            fatalError("Error fetching muscle groups data! \(error)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            if mixlists.count == 0 {
                return 1
            } else {
                return mixlists.count
            }
        default:
            return 1
        }

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MixlistCell", forIndexPath: indexPath)

        switch indexPath.section {
        case 0:
            if mixlists.count == 0 {
                cell.textLabel?.text = "You have not created any mixlists"
            } else {
                let mixlist = mixlists[indexPath.row]
                let cellTitle: String = mixlist.name
                cell.textLabel?.text = cellTitle.uppercaseString
                cell.accessoryType = .DisclosureIndicator
            }
        default:
//            let muscleGroup = favMuscleGroups[indexPath.row]
            let cellTitle: String = "Favorites"
            cell.textLabel?.text = cellTitle.uppercaseString
            cell.accessoryType = .DisclosureIndicator
        }


        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
        let header = cell as! TableSectionHeader

        switch section {
        case 0:
            header.titleLabel.text = "CUSTOM MIXLISTS"
        default:
            header.titleLabel.text = "FAVORITES"
        }


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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let selectedCell = sender as? UITableViewCell, let selectedRowIndexPath = tableView.indexPathForCell(selectedCell) {
            let destinationViewController = segue.destinationViewController as? MixlistDetailTableViewController

            if selectedRowIndexPath.section == 0 {
                let mixlist = mixlists[selectedRowIndexPath.row]
                destinationViewController?.mixlist = mixlist
                destinationViewController?.mixlistName = mixlist.name
                destinationViewController?.isFavoritesMixlist = false
            } else {
//                let muscleGroup = favMuscleGroups[selectedRowIndexPath.row]
//                destinationViewController?.muscleGroup = muscleGroup
                destinationViewController?.isFavoritesMixlist = true
                destinationViewController?.mixlistName = "FAVORITES"
            }
        }


    }


    @IBAction func unwindToMixlists(segue: UIStoryboardSegue) {
        self.reloadData()
    }

}
