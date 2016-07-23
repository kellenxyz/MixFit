//
//  AddToMixlistTableViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 7/13/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

protocol AddToMixlistDelegate {
    func exerciseAddedToMixlist(mixlistName: String)
}

class AddToMixlistTableViewController: UITableViewController {

    var coreDataStack = CoreDataStack.sharedInstance
    var exercise: Exercise!
    var fetchedResultsController: NSFetchedResultsController!
    var delegate: AddToMixlistDelegate?

    @IBOutlet weak var cancelButton: UIBarButtonItem!


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add to mixlist".uppercaseString

        // Instantiate the fetchedResultsController
        let fetchRequest = NSFetchRequest(entityName: "UserCreatedMixlist")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: coreDataStack.managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        // A little tableView UI setup
        tableView.separatorColor = UIColor(colorLiteralRed: 0.88, green: 0.88, blue: 0.88, alpha: 1)
        tableView.tableFooterView = UIView()
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

        let cellTitle: String = mixlist.name
        cell.textLabel?.text = cellTitle.uppercaseString

        if let exercises = mixlist.exercises {
            if exercises.containsObject(self.exercise) {
                cell.accessoryType = .Checkmark
                cell.tintColor = UIColor(colorLiteralRed: 203.0/255.0, green: 51.0/255.0, blue: 0.0, alpha: 1.0)
                cell.userInteractionEnabled = false
                cell.backgroundColor = UIColor(colorLiteralRed: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
                cell.textLabel?.textColor = UIColor(colorLiteralRed: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            }
        } else {
            cell.accessoryType = .None
            cell.userInteractionEnabled = true
            cell.backgroundColor = UIColor.whiteColor()
            cell.textLabel?.textColor = UIColor(colorLiteralRed: 0.098, green: 0.098, blue: 0.098, alpha: 1.0)
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let mixlist = fetchedResultsController.objectAtIndexPath(indexPath) as! UserCreatedMixlist

        let exercisesRelation = mixlist.mutableSetValueForKey("exercises")
        exercisesRelation.addObject(self.exercise)

        coreDataStack.saveMainContext()

        self.dismissViewControllerAnimated(true) { 
            self.delegate?.exerciseAddedToMixlist(mixlist.name)
        }
//        self.performSegueWithIdentifier("UnwindToExerciseViewController", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - IBActions
    
    @IBAction func onCancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
