//
//  EditMixlistTableViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/29/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit

class EditMixlistTableViewController: UITableViewController {

    var coreDataStack = CoreDataStack.sharedInstance

    var options: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        options = ["Exercises"]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath as NSIndexPath).row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteCell", for: indexPath)
            cell.textLabel?.text = "Delete mixlist"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)

            let cellTitle: String = options[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = cellTitle

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if (indexPath as NSIndexPath).row == 1 {
            let alertController = UIAlertController(title: "Delete mixlist?", message: "Are you sure you wish to delete this mixlist? This action cannot be undone.", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete mixlist", style: .destructive, handler: { (action) in
                // Delete mixlist from data model
//                alertController.dismissViewControllerAnimated(true, completion: { 
//                    self.performSegueWithIdentifier("UnwindToMixlists", sender: self)
//                })
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)

        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func onCancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onSaveButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
