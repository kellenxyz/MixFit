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

    var coreDataStack = CoreDataStack.sharedInstance

    var mixlists: [UserCreatedMixlist] = [UserCreatedMixlist]()
    var favMuscleGroups: [MuscleGroup] = [MuscleGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorColor = UIColor(colorLiteralRed: 0.92, green: 0.92, blue: 0.92, alpha: 1)

        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")

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
        if let selectedCell = sender as? UITableViewCell, let selectedRowIndexPath = tableView.indexPathForCell(selectedCell) {
            let destinationViewController = segue.destinationViewController as? MixlistDetailTableViewController

            if selectedRowIndexPath.section == 0 {
                let mixlist = mixlists[selectedRowIndexPath.row]
                destinationViewController?.mixlist = mixlist
                destinationViewController?.mixlistName = mixlist.name
                destinationViewController?.isFavoritesMixlist = false
            } else {
                destinationViewController?.isFavoritesMixlist = true
                destinationViewController?.mixlistName = "FAVORITES"
            }
        }
    }

    @IBAction func unwindToMixlists(segue: UIStoryboardSegue) {
        self.reloadData()
    }

    // Unwind after delete from MixlistDetail and handle deletion from data source
    @IBAction func deleteMixlistFromDataSource(segue: UIStoryboardSegue) {
        if let sourceVC = segue.sourceViewController as? MixlistDetailTableViewController,
        let mixlist = sourceVC.mixlist {
            let mixlistName = mixlist.name
            guard let index = mixlists.indexOf(mixlist)
                else {
                    fatalError("Could not find index for mixlist!")
            }
//            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.mixlists.removeAtIndex(index)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.coreDataStack.managedObjectContext.deleteObject(mixlist)
            self.coreDataStack.saveMainContext()

            self.reloadData()

            self.notificationAlertWithTitle("Deleted \"\(mixlistName)\"")
        }
    }

}
