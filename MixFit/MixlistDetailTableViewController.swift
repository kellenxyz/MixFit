//
//  MixlistDetailTableViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/21/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

class MixlistDetailTableViewController: UITableViewController {

    var coreDataStack = CoreDataStack.sharedInstance
    var exercises = [Exercise]()
    var mixlist: UserCreatedMixlist?
    var mixlistName: String!
    var isFavoritesMixlist: Bool = false
    var fetchedResultsController: NSFetchedResultsController<Exercise>!

    let kTableHeaderHeight: CGFloat = 180.0
    var headerView: UIView!

    @IBOutlet weak var startMixlistButton: CustomButton!
    @IBOutlet weak var mixlistNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove bottom line on navBar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        self.mixlistNameLabel.text = self.mixlistName.uppercased()

        if isFavoritesMixlist {
            navigationItem.rightBarButtonItems = []
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // Assign storyboard headerView to headerView property
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)

        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)

        updateHeaderView()

        tableView.separatorColor = UIColor(colorLiteralRed: 0.92, green: 0.92, blue: 0.92, alpha: 1)

//        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isFavoritesMixlist {
            reloadFavoritesData()
        } else {
            reloadMixlistData()
        }

        instantiateViewForNoExercises()
        updateStartMixlistButton()
    }

    func reloadMixlistData() {

        if let exercises = self.mixlist?.exercises  {
            let fetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true)
            ]
            fetchRequest.predicate = NSPredicate(format: "SELF IN %@", exercises)

            do {
                let results = try coreDataStack.managedObjectContext.fetch(fetchRequest)
                self.exercises = results
            } catch {
                fatalError("Error fetching exercises data for mixlist \(error)")
            }
        }

        tableView.reloadData()
    }

    func reloadFavoritesData() {

        let fetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")

        do {
            let results = try coreDataStack.managedObjectContext.fetch(fetchRequest)
            self.exercises = results
        } catch {
            fatalError("Error fetching data! \(error)")
        }

        tableView.reloadData()
    }

    func updateStartMixlistButton() {
        if self.exercises.count <= 0 {
            self.startMixlistButton.isEnabled = false
            self.startMixlistButton.borderColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        } else {
            self.startMixlistButton.isEnabled = true
            self.startMixlistButton.borderColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }

    func instantiateViewForNoExercises() {

        if self.exercises.count <= 0 {
            let testView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 150))

            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 80, height: 60))
            label.center = testView.center
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.center
            if isFavoritesMixlist {
                label.text = "You have not favorited any exercises"
            } else {
                label.text = "You have not added any exercises to this mixlist"
            }
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
            label.alpha = 0
            testView.addSubview(label)

            self.tableView.tableFooterView = testView

            UIView.animate(withDuration: 1.0, animations: {
                label.alpha = 1.0
            }) 
        } else {
            self.tableView.tableFooterView = UIView()
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
        updateNavBarTitle()
    }

    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }

        headerView.frame = headerRect
    }

    // Fade in nav bar title after title in tableView header disappears
    func updateNavBarTitle() {

        let fadeInStart = CGFloat(-130.0)
//        let fadeInEnd = CGFloat(-110)

        if tableView.contentOffset.y >= fadeInStart {

//            var alphaValue: Float
//            if tableView.contentOffset.y <= fadeInEnd {
//                let x = tableView.contentOffset.y - fadeInStart
//                let diff = (fadeInEnd - fadeInStart)
//                alphaValue = Float(x / diff)
//            } else {
//                alphaValue = 1.0
//            }
//
//            let titleColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: alphaValue)
//
//            if let font = UIFont(name: "RobotoCondensed-Bold", size: 16) {
//                self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: titleColor]
//            }

            self.title = self.mixlistName.uppercased()

        } else {
            self.title = ""
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exercises.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)

        let exercise = exercises[(indexPath as NSIndexPath).row]

        cell.textLabel?.text = exercise.name
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if isFavoritesMixlist {
                let alertController = UIAlertController(title: "Unfavorite exercise?", message: "Are you sure you wish to remove this exercise from your favorites?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let removeAction = UIAlertAction(title: "Unfavorite", style: .destructive, handler: { (action) in
                    let exercise = self.exercises[(indexPath as NSIndexPath).row]
                    exercise.isFavorite = false
                    self.exercises.remove(at: (indexPath as NSIndexPath).row)
                    self.updateStartMixlistButton()
                    self.instantiateViewForNoExercises()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.coreDataStack.saveMainContext()
                })
                alertController.addAction(cancelAction)
                alertController.addAction(removeAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Remove exercise?", message: "Are you sure you wish to remove this exercise from this mixlist?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                    let exercise = self.exercises[(indexPath as NSIndexPath).row]
                    let exercisesRelation = self.mixlist?.mutableSetValue(forKey: "exercises")
                    exercisesRelation?.remove(exercise)
                    self.exercises.remove(at: (indexPath as NSIndexPath).row)
                    self.updateStartMixlistButton()
                    self.instantiateViewForNoExercises()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.coreDataStack.saveMainContext()
                })
                alertController.addAction(cancelAction)
                alertController.addAction(removeAction)
                self.present(alertController, animated: true, completion: nil)
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }

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

    @IBAction func onStartMixlistButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowExercisePageController", sender: self)
    }

    @IBAction func onOptionsButtonPressed(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Mixlist Options", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let rename = UIAlertAction(title: "Rename", style: .default) { (action) in
            // present rename view controller
            self.performSegue(withIdentifier: "RenameMixlistSegue", sender: self)
        }
        let addExercises = UIAlertAction(title: "Add Exercises", style: .default) { (action) in
            // present add exercises view controller
        }
        let deleteMixlist = UIAlertAction(title: "Delete Mixlist", style: .destructive) { (action) in
            guard let name = self.mixlistName else { fatalError("Could not find a value for self.mixlistName") }
            let alertController = UIAlertController(title: "Delete \"\(name)\"?", message: "Are you sure you wish to delete this mixlist? This action cannot be undone.", preferredStyle: .alert)
            let cancelDelete = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                // delete mixlist
                self.performSegue(withIdentifier: "DeleteMixlistFromDataSource", sender: self)
            })
            alertController.addAction(cancelDelete)
            alertController.addAction(delete)
            self.present(alertController, animated: true, completion: { 
                // take any further actions required here
            })
        }
        actionSheet.addAction(rename)
        actionSheet.addAction(addExercises)
        actionSheet.addAction(deleteMixlist)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true) { 
            // take any further actions required
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ShowExercisePageController" {
            let navController = segue.destination as? UINavigationController
            let destinationViewController = navController?.topViewController as? ExercisePageViewController
            destinationViewController?.mixlistName = self.mixlistName
            destinationViewController?.coreDataStack = self.coreDataStack
            destinationViewController?.pageCount = self.exercises.count
            destinationViewController?.exercises = self.exercises.shuffle()
        } else if segue.identifier == "RenameMixlistSegue" {
            let navController = segue.destination as? UINavigationController
            let destinationViewController = navController?.topViewController as? NewMixlistViewController
            destinationViewController?.mixlist = self.mixlist
            destinationViewController?.newTitle = "RENAME MIXLIST"
        } else if segue.identifier == "ShowExerciseDetailSegue" {
            guard let selectedCell = sender as? UITableViewCell, let selectedRowIndexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("Sender is not a UITableViewCell or was not found in the tableView, or segue.identifier is not correct")
            }

            let exercise = exercises[(selectedRowIndexPath as NSIndexPath).row]

            let destinationViewController = segue.destination as? ExerciseDetailViewController
            destinationViewController?.exercise = exercise
        }
    }


    @IBAction func unwindToMixlistDetail(_ segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? NewMixlistViewController,
            let mixlist = sourceVC.mixlist {
            self.mixlistName = mixlist.name
            self.mixlistNameLabel.text = self.mixlistName.uppercased()
        }
    }

}
