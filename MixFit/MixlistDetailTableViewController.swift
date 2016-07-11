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

    let kTableHeaderHeight: CGFloat = 180.0
    var headerView: UIView!

    @IBOutlet weak var startMixlistButton: CustomButton!
    @IBOutlet weak var mixlistNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove bottom line on navBar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()

        self.mixlistNameLabel.text = self.mixlistName.uppercaseString

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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if isFavoritesMixlist {
            reloadFavoritesData()
        }

        instantiateViewForNoExercises()

        updateStartMixlistButton()
    }

    func reloadFavoritesData() {
        let fetchRequest = NSFetchRequest(entityName: "Exercise")
        let predicate = NSPredicate(format: "isFavorite == true")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]

        do {
            if let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [Exercise] {
                exercises = results
            }
        } catch {
            fatalError("Error fetching data! \(error)")
        }

        tableView.reloadData()
    }

    func updateStartMixlistButton() {
        if self.exercises.count <= 0 {
            self.startMixlistButton.enabled = false
            self.startMixlistButton.borderColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        } else {
            self.startMixlistButton.enabled = true
            self.startMixlistButton.borderColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }

    func instantiateViewForNoExercises() {

        if self.exercises.count <= 0 {
            let testView = UIView(frame: CGRectMake(0, 0, view.frame.width, 150))

            let label = UILabel(frame: CGRectMake(0, 0, view.frame.width - 80, 60))
            label.center = testView.center
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.Center
            if isFavoritesMixlist {
                label.text = "You have not favorited any exercises"
            } else {
                label.text = "You have not added any exercises to this mixlist"
            }
            label.font = UIFont.systemFontOfSize(14)
            label.textColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
            label.alpha = 0
            testView.addSubview(label)

            self.tableView.tableFooterView = testView

            UIView.animateWithDuration(1.0) {
                label.alpha = 1.0
            }
        } else {
            self.tableView.tableFooterView = UIView()
        }
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
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
        let fadeInEnd = CGFloat(-110)

        if tableView.contentOffset.y >= fadeInStart {

            var alphaValue: Float
            if tableView.contentOffset.y <= fadeInEnd {
                let x = tableView.contentOffset.y - fadeInStart
                let diff = (fadeInEnd - fadeInStart)
                alphaValue = Float(x / diff)
            } else {
                alphaValue = 1.0
            }

            let titleColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: alphaValue)

            if let font = UIFont(name: "RobotoCondensed-Bold", size: 16) {
                self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: titleColor]
            }

            self.title = self.mixlistName.uppercaseString

        } else {
            self.title = ""
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exercises.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell", forIndexPath: indexPath)

        let exercise = exercises[indexPath.row]

        cell.textLabel?.text = exercise.name
        cell.accessoryType = .DisclosureIndicator

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if isFavoritesMixlist {
                let alertController = UIAlertController(title: "Unfavorite exercise?", message: "Are you sure you wish to remove this exercise from your favorites?", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                let removeAction = UIAlertAction(title: "Unfavorite", style: .Destructive, handler: { (action) in
                    let exercise = self.exercises[indexPath.row]
                    exercise.isFavorite = false
                    self.exercises.removeAtIndex(indexPath.row)
                    self.updateStartMixlistButton()
                    self.instantiateViewForNoExercises()
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    self.coreDataStack.saveMainContext()
                })
                alertController.addAction(cancelAction)
                alertController.addAction(removeAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Remove exercise?", message: "Are you sure you wish to remove this exercise from this mixlist?", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                let removeAction = UIAlertAction(title: "Remove", style: .Destructive, handler: { (action) in
                    self.exercises.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
                alertController.addAction(cancelAction)
                alertController.addAction(removeAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
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

    @IBAction func onStartMixlistButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("ShowExercisePageController", sender: self)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowExercisePageController" {
            let navController = segue.destinationViewController as? UINavigationController
            let destinationViewController = navController?.topViewController as? ExercisePageViewController
            destinationViewController?.mixlistName = self.mixlistName
            destinationViewController?.coreDataStack = self.coreDataStack
            destinationViewController?.pageCount = self.exercises.count
            destinationViewController?.exercises = self.exercises.shuffle()
        }
    }


    @IBAction func unwindToMixlistDetail(segue: UIStoryboardSegue) {
        
    }

}
