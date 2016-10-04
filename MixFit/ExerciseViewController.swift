//
//  ExerciseViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/15/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

class ExerciseViewController: UIViewController {

    var coreDataStack = CoreDataStack.sharedInstance

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var setsAndRepsLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: CustomButton!
    @IBOutlet weak var addToMixlistButton: UIButton!
    @IBOutlet weak var targetedMuscleGroupsLabel: UILabel!
    @IBOutlet weak var trainersNotesLabel: UILabel!

    var page = 0

    var exercise: Exercise?
    var exerciseVolumes: [ExerciseVolume]?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadExerciseData()
        setFavoriteButtonTitle()

        scrollView.contentSize.width = view.frame.width
//        let topInset = CGRectGetHeight(navigationController!.navigationBar.frame) + CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
//        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
//        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)

    }

    /// Fetches exercise data from MOC and populates the view with the current exercise's data
    fileprivate func loadExerciseData() {
        guard let exercise = self.exercise else {
            fatalError("Could not find exercise object")
        }

        let fetchRequest = NSFetchRequest<ExerciseVolume>(entityName: "ExerciseVolume")
        do {
            self.exerciseVolumes = try coreDataStack.managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalError("Error fetching data!")
        }

        // Select a random exercise volume
        if let exerciseVolumes = self.exerciseVolumes {
            let randomNumber = Int(arc4random_uniform(UInt32(exerciseVolumes.count)))
            let exerciseVolume = exerciseVolumes[randomNumber]
            setsAndRepsLabel.text = exerciseVolume.setsAndReps
            restTimeLabel.text = "\(exerciseVolume.restTime) rest"
        }
        exerciseNameLabel.text = exercise.name.uppercased()
        targetedMuscleGroupsLabel.text = exercise.targetedMuscles
        trainersNotesLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//        trainersNotesLabel.text = exercise.detailDescription
        if let defaultExercise = exercise as? DefaultExercise {
            let exerciseID = defaultExercise.exerciseID ?? "No id"
            print(exerciseID)
        }
        
    }


    /// Toggles state / appearance of favorite button
    fileprivate func setFavoriteButtonTitle() {
        guard let exercise = self.exercise else {
            fatalError("Could not find exercise object")
        }

        if exercise.isFavorite.boolValue {
            addToFavoritesButton.setTitle("❤️ Favorited", for: UIControlState())
            addToFavoritesButton.setTitleColor(UIColor.red, for: .normal)
            addToFavoritesButton.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        } else {
            addToFavoritesButton.setTitle("+ Add to Favorites", for: UIControlState())
            addToFavoritesButton.setTitleColor(UIColor.black, for: .normal)
            addToFavoritesButton.backgroundColor = UIColor.white
        }
    }

    @IBAction func onAddToFavoritesButtonPressed(_ sender: UIButton) {
        guard let exercise = self.exercise else {
            fatalError("Could not find exercise object")
        }

        UIView.animate(withDuration: 0.06, animations: {
            self.addToFavoritesButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            }) { (Bool) in
                UIView.animate(withDuration: 0.06, animations: {
                    self.addToFavoritesButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
        }

        if exercise.isFavorite.boolValue == false {
            exercise.setValue(!exercise.isFavorite.boolValue, forKey: "isFavorite")
            coreDataStack.saveMainContext()
            notificationAlertWithTitle("Added to Favorites")
            print(exercise.isFavorite.boolValue)
        } else {
            exercise.setValue(!exercise.isFavorite.boolValue, forKey: "isFavorite")
            coreDataStack.saveMainContext()
            notificationAlertWithTitle("Removed from Favorites")
            print(exercise.isFavorite.boolValue)
        }

        setFavoriteButtonTitle()
    }

    @IBAction func onAddToMixlistButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.06, animations: {
            self.addToMixlistButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (Bool) in
            UIView.animate(withDuration: 0.06, animations: {
                self.addToMixlistButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
//        print("Add to a mixlist!")
        self.performSegue(withIdentifier: "ShowMixlistsSegue", sender: self)
    }

    func notificationAlertWithTitle(_ title: String) {
        guard let notificationAlert = storyboard!.instantiateViewController(withIdentifier: "NotificationAlert") as? NotificationAlertViewController else {
            fatalError("Could not instantiate Notification Alert ViewController")
        }

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowMixlistsSegue" {
            let navController = segue.destination as? UINavigationController
            let destinationViewController = navController?.topViewController as? AddToMixlistTableViewController
            destinationViewController?.exercise = self.exercise
            destinationViewController?.delegate = self
        }
    }

    @IBAction func unwindToExerciseViewController(_ segue: UIStoryboardSegue) {

    }
    

}

extension ExerciseViewController: AddToMixlistDelegate {

    func exerciseAddedToMixlist(_ mixlistName: String) {
        let alertTitle = "Added to \"\(mixlistName)\""
        self.notificationAlertWithTitle(alertTitle.uppercased())
    }

}








