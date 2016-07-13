//
//  AddToMixlistTableViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 7/13/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

class AddToMixlistTableViewController: UITableViewController {

    var coreDataStack = CoreDataStack.sharedInstance
    var exercise: Exercise!
    var fetchedResultsController: NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add to mixlist".uppercaseString

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        let fetchRequest = NSFetchRequest(entityName: "UserCreatedMixlist")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: coreDataStack.managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()
    }

    func reloadData() {

//        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "")

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Error")
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MixlistCell", forIndexPath: indexPath)

        let mixlist = fetchedResultsController.objectAtIndexPath(indexPath) as! UserCreatedMixlist

        cell.textLabel?.text = mixlist.name

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let mixlist = fetchedResultsController.objectAtIndexPath(indexPath) as! UserCreatedMixlist

        let exercisesRelation = mixlist.mutableSetValueForKey("exercises")
        exercisesRelation.addObject(self.exercise)

        coreDataStack.saveMainContext()

        self.dismissViewControllerAnimated(true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
