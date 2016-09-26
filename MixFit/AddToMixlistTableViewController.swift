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
    func exerciseAddedToMixlist(_ mixlistName: String)
}

class AddToMixlistTableViewController: UITableViewController {

    var coreDataStack = CoreDataStack.sharedInstance
    var exercise: Exercise!
    var fetchedResultsController: NSFetchedResultsController<UserCreatedMixlist>!
    var delegate: AddToMixlistDelegate?

    @IBOutlet weak var cancelButton: UIBarButtonItem!


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add to mixlist".uppercased()

        // Instantiate the fetchedResultsController
        let fetchRequest = NSFetchRequest<UserCreatedMixlist>(entityName: "UserCreatedMixlist")
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

    override func viewWillAppear(_ animated: Bool) {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MixlistCell", for: indexPath)

        let mixlist = fetchedResultsController.object(at: indexPath)

        let cellTitle: String = mixlist.name
        cell.textLabel?.text = cellTitle.uppercased()

        if let exercises = mixlist.exercises {
            if exercises.contains(self.exercise) {
                cell.accessoryType = .checkmark
                cell.tintColor = UIColor(colorLiteralRed: 203.0/255.0, green: 51.0/255.0, blue: 0.0, alpha: 1.0)
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = UIColor(colorLiteralRed: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
                cell.textLabel?.textColor = UIColor(colorLiteralRed: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            }
        } else {
            cell.accessoryType = .none
            cell.isUserInteractionEnabled = true
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor(colorLiteralRed: 0.098, green: 0.098, blue: 0.098, alpha: 1.0)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let mixlist = fetchedResultsController.object(at: indexPath)

        let exercisesRelation = mixlist.mutableSetValue(forKey: "exercises")
        exercisesRelation.add(self.exercise)

        coreDataStack.saveMainContext()

        self.dismiss(animated: true) { 
            self.delegate?.exerciseAddedToMixlist(mixlist.name)
        }
//        self.performSegueWithIdentifier("UnwindToExerciseViewController", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - IBActions
    
    @IBAction func onCancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
