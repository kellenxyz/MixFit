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
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")

        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        if let font = UIFont(name: "RobotoCondensed-Bold", size: 16) {
//            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white]
//        }

        reloadData()
    }

    func reloadData() {
        let fetchRequest = NSFetchRequest<UserCreatedMixlist>(entityName: "UserCreatedMixlist")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]

        do {
            let results = try coreDataStack.managedObjectContext.fetch(fetchRequest)
            mixlists = results
        } catch {
            fatalError("Error fetching data! \(error)")
        }

        tableView.reloadData()
    }

    /*
    func loadFavoritesData() {
        let fetchRequest = NSFetchRequest<MuscleGroup>(entityName: "MuscleGroup")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]

        do {
            if let results = try coreDataStack.managedObjectContext.fetch(fetchRequest) as? [MuscleGroup] {
                favMuscleGroups = results
            }
        } catch {
            fatalError("Error fetching muscle groups data! \(error)")
        }
    }
    */

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 1
        default:
            if mixlists.count == 0 {
                return 1
            } else {
                return mixlists.count
            }
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MixlistCell", for: indexPath)

        switch (indexPath as NSIndexPath).section {
        case 0:
            let cellTitle: String = "Favorites"
            cell.textLabel?.text = cellTitle.uppercased()
            cell.accessoryType = .disclosureIndicator
        default:
            if mixlists.count == 0 {
                cell.textLabel?.text = "You have not created any mixlists"
            } else {
                let mixlist = mixlists[(indexPath as NSIndexPath).row]
                let cellTitle: String = mixlist.name
                cell.textLabel?.text = cellTitle.uppercased()
                cell.accessoryType = .disclosureIndicator
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
        let header = cell as! TableSectionHeader

        switch section {
        case 0:
            header.titleLabel.text = ""
        default:
            header.titleLabel.text = "CUSTOM MIXLISTS"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 40.0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    // MARK: - Notification Alert

    func notificationAlertWithTitle(_ title: String) {
        let notificationAlert = storyboard!.instantiateViewController(withIdentifier: "NotificationAlert") as! NotificationAlertViewController

        // Get height of status bar + nav bar (only if translucent navbar)
        //        let topInset = CGRectGetHeight(navigationController!.navigationBar.frame) + CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)

        // Create notification view
        let notificationFrameView = UIView(frame: CGRect(x: 0, y: -50, width: view.frame.width, height: 50))

        // Specify frame for notification alert vc view
        notificationAlert.view.frame = CGRect(x: 0, y: 0, width: notificationFrameView.frame.width, height: notificationFrameView.frame.height)

        // Set title text for notification alert view
        notificationAlert.notificationTitleLabel.text = title.uppercased()

        // Add notification alert vc to current vc
        addChildViewController(notificationAlert)
        notificationFrameView.addSubview(notificationAlert.view)
        notificationAlert.didMove(toParentViewController: self)

        // Add the notification view to the main view
        view.addSubview(notificationFrameView)

        // And finally animate the notification bar down...
        UIView.animate(withDuration: 0.2, animations: {
            notificationFrameView.frame.origin.y =  -1
        }, completion: { (Bool) in
            // ...and back up after a slight delay
            UIView.animate(withDuration: 0.4, delay: 1.8, options: [], animations: {
                notificationFrameView.frame.origin.y = -70
                }, completion: { (Bool) in
                    notificationFrameView.removeFromSuperview()
            })
        }) 
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? UITableViewCell, let selectedRowIndexPath = tableView.indexPath(for: selectedCell) {
            let destinationViewController = segue.destination as? MixlistDetailTableViewController

            if (selectedRowIndexPath as NSIndexPath).section == 1 {
                let mixlist = mixlists[(selectedRowIndexPath as NSIndexPath).row]
                destinationViewController?.mixlist = mixlist
                destinationViewController?.mixlistName = mixlist.name
                destinationViewController?.isFavoritesMixlist = false
            } else {
                destinationViewController?.isFavoritesMixlist = true
                destinationViewController?.mixlistName = "FAVORITES"
            }
        }
    }

    @IBAction func unwindToMixlists(_ segue: UIStoryboardSegue) {
        self.reloadData()
    }

    // Unwind after delete from MixlistDetail and handle deletion from data source
    @IBAction func deleteMixlistFromDataSource(_ segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? MixlistDetailTableViewController,
        let mixlist = sourceVC.mixlist {
            let mixlistName = mixlist.name
            guard let index = mixlists.index(of: mixlist)
                else {
                    fatalError("Could not find index for mixlist!")
            }
//            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.mixlists.remove(at: index)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.coreDataStack.managedObjectContext.delete(mixlist)
            self.coreDataStack.saveMainContext()

            self.reloadData()

            self.notificationAlertWithTitle("Deleted \"\(mixlistName)\"")
        }
    }

}
