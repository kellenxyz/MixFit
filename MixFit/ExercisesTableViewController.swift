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
    var fetchedResultsController: NSFetchedResultsController<Exercise>!
//    var muscleGroups = [MuscleGroup]()
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeFetchedResultsController(nil)

//        configureSearchController()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // Change color of cell separators
        tableView.separatorColor = UIColor(colorLiteralRed: 0.88, green: 0.88, blue: 0.88, alpha: 1)

        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()
    }

    func initializeFetchedResultsController(_ predicate: NSPredicate?) {
        let request = NSFetchRequest<Exercise>(entityName: "Exercise")

        if let predicate = predicate {
            request.predicate = predicate
        }

        let muscleGroupSort = NSSortDescriptor(key: "muscleGroup.name", ascending: true)
        let exerciseNameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [muscleGroupSort, exerciseNameSort]

        let moc = self.coreDataStack.managedObjectContext

        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "muscleGroup.name", cacheName: nil)
//        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }

        tableView.reloadData()
    }

    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search exercises"
        searchController.searchBar.tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)

        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()

        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil

        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false

        searchController.searchBar.becomeFirstResponder()
    }


    func reloadData() {

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }

        tableView.reloadData()
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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }

    func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let exercise = fetchedResultsController.object(at: indexPath)

        if exercise.isFavorite == true && exercise == exercise as? UserCreatedExercise {
            cell.textLabel?.text = exercise.name + " ❤️" + " 💪🏼"
        } else if exercise.isFavorite == true {
            cell.textLabel?.text = exercise.name + " ❤️"
        } else if exercise == exercise as? UserCreatedExercise {
            cell.textLabel?.text = exercise.name + " 💪🏼"
        } else {
            cell.textLabel?.text = exercise.name
        }

        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)

        configureCell(cell, indexPath: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
        let header = cell as! TableSectionHeader
        header.titleLabel.text = fetchedResultsController.sections?[section].name.uppercased()

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

    @IBAction func onSearchButtonPressed(_ sender: UIBarButtonItem) {
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
        performSegue(withIdentifier: "NewExerciseSegue", sender: self)
    }


    // MARK: - Notification Alert


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ShowExerciseDetailSegue" {
            guard let selectedCell = sender as? UITableViewCell, let selectedRowIndexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("Sender is not a UITableViewCell or was not found in the tableView, or segue.identifier is not correct")
            }

            let exercise = fetchedResultsController.object(at: selectedRowIndexPath)
            let destinationVC = segue.destination as? ExerciseDetailViewController
            destinationVC?.exercise = exercise
        }

    }

    @IBAction func deleteExerciseFromDataSource(_ segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? ExerciseDetailViewController,
        let exercise = sourceVC.exercise {
//            let exerciseName: String = exercise.name

            self.coreDataStack.managedObjectContext.delete(exercise)
            self.coreDataStack.saveMainContext()

            

//            self.notificationAlertWithTitle("Deleted \"\(exerciseName)\"")
        }
    }


}

/*
extension ExercisesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            configureCell(self.tableView.cellForRow(at: indexPath!)!, indexPath: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [indexPath!], with: .fade)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
*/

extension ExercisesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {

        // Process the search string, remove leading and trailing spaces
        let searchText = searchController.searchBar.text!
        let trimmedSearchString = searchText.trimmingCharacters(in: CharacterSet.whitespaces)

        // If search string is not blank
        if trimmedSearchString != "" {
            // Form the search format
            let predicate = NSPredicate(format: "name contains [c] %@", trimmedSearchString)

            // Add the search filter
            initializeFetchedResultsController(predicate)

            tableView.tableFooterView = UIView()
        } else {
            initializeFetchedResultsController(nil)
        }

//        reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Remove search bar from nav bar and display left and right bar button items
        navigationItem.titleView = nil

        let searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(ExercisesTableViewController.onSearchBarButtonPressed))
        searchItem.tintColor = UIColor.white

        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ExercisesTableViewController.onAddExerciseBarButtonPressed))
        addItem.tintColor = UIColor.white

        navigationItem.leftBarButtonItem = searchItem
        navigationItem.rightBarButtonItem = addItem

    }
}












