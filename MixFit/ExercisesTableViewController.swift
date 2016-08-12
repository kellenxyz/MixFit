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

    var coreDataStack = CoreDataStack.sharedInstance
    var fetchedResultsController: NSFetchedResultsController!
//    var muscleGroups = [MuscleGroup]()
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchedResultsController = getFRC()

//        configureSearchController()

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

    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search exercises"
        searchController.searchBar.tintColor = UIColor.whiteColor()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).textColor = UIColor.whiteColor()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)

        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()

        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil

        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false

        searchController.searchBar.becomeFirstResponder()
    }


    func getFRC() -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(entityName: "Exercise")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "muscleGroup.name", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: coreDataStack.managedObjectContext,
                                                              sectionNameKeyPath: "muscleGroup.name",
                                                              cacheName: nil)
        return fetchedResultsController
    }


    func reloadData() {
//        fetchedResultsController.fetchRequest.predicate = predicate

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Error fetching data! \(error)")
        }

        tableView.reloadData()
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

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell", forIndexPath: indexPath)

        let exercise = fetchedResultsController.objectAtIndexPath(indexPath) as! Exercise

        if exercise.isFavorite == true {
            cell.textLabel?.text = exercise.name + " ❤️"
        } else {
            cell.textLabel?.text = exercise.name
        }

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
        let header = cell as! TableSectionHeader
        header.titleLabel.text = fetchedResultsController.sections?[section].name.uppercaseString

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

    // MARK: - IBActions

    @IBAction func onSearchButtonPressed(sender: UIBarButtonItem) {
        configureSearchController()
    }

    func onSearchBarButtonPressed() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.becomeFirstResponder()
    }

    func onAddExerciseBarButtonPressed() {
//        print("Add exercise here!")
        performSegueWithIdentifier("NewExerciseSegue", sender: self)
    }


    // MARK: - Notification Alert

    func notificationAlertWithTitle(title: String) {
        let notificationAlert = storyboard!.instantiateViewControllerWithIdentifier("NotificationAlert") as! NotificationAlertViewController

         // Get height of status bar + nav bar (only if translucent navbar)
//        let topInset = CGRectGetHeight(navigationController!.navigationBar.frame) + CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)

        // Create notification view
        let notificationFrameView = UIView(frame: CGRectMake(0, -50, view.frame.width, 50))

        // Specify frame for notification alert vc view
        notificationAlert.view.frame = CGRectMake(0, 0, notificationFrameView.frame.width, notificationFrameView.frame.height)

        // Set title text for notification alert view
        notificationAlert.notificationTitleLabel.text = title.uppercaseString

        // Add notification alert vc to current vc
        addChildViewController(notificationAlert)
        notificationFrameView.addSubview(notificationAlert.view)
        notificationAlert.didMoveToParentViewController(self)

        // Add the notification view to the main view
        view.addSubview(notificationFrameView)

        // And finally animate the notification bar down...
        UIView.animateWithDuration(0.2, animations: {
            notificationFrameView.frame.origin.y =  -1
        }) { (Bool) in
            // ...and back up after a slight delay
            UIView.animateWithDuration(0.4, delay: 1.8, options: [], animations: {
                notificationFrameView.frame.origin.y = -70
                }, completion: { (Bool) in
                    notificationFrameView.removeFromSuperview()
            })
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "ShowExerciseDetailSegue" {
            guard let selectedCell = sender as? UITableViewCell, let selectedRowIndexPath = tableView.indexPathForCell(selectedCell) else {
                fatalError("Sender is not a UITableViewCell or was not found in the tableView, or segue.identifier is not correct")
            }

            let exercise = fetchedResultsController.objectAtIndexPath(selectedRowIndexPath) as! Exercise
            let destinationVC = segue.destinationViewController as? ExerciseDetailViewController
            destinationVC?.exercise = exercise
        }

    }

    @IBAction func deleteExerciseFromDataSource(segue: UIStoryboardSegue) {
        if let sourceVC = segue.sourceViewController as? ExerciseDetailViewController,
        let exercise = sourceVC.exercise {
            let exerciseName: String = exercise.name

            self.coreDataStack.managedObjectContext.deleteObject(exercise)
            self.coreDataStack.saveMainContext()

            reloadData()

            self.notificationAlertWithTitle("Deleted \"\(exerciseName)\"")
        }
    }


}

extension ExercisesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResultsForSearchController(searchController: UISearchController) {

        // Process the search string, remove leading and trailing spaces
        let searchText = searchController.searchBar.text!
        let trimmedSearchString = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

        // If search string is not blank
        if trimmedSearchString != "" {
            // Form the search format
            let predicate = NSPredicate(format: "name contains [c] %@", trimmedSearchString)

            // Add the search filter
            fetchedResultsController.fetchRequest.predicate = predicate

            tableView.tableFooterView = UIView()
        } else {
            getFRC()
        }

        reloadData()
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // Remove search bar from nav bar and display left and right bar button items
        navigationItem.titleView = nil

        let searchItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(ExercisesTableViewController.onSearchBarButtonPressed))
        searchItem.tintColor = UIColor.whiteColor()

        let addItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ExercisesTableViewController.onAddExerciseBarButtonPressed))
        addItem.tintColor = UIColor.whiteColor()

        navigationItem.leftBarButtonItem = searchItem
        navigationItem.rightBarButtonItem = addItem
    }
}












