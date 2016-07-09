//
//  ExercisePageViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/15/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit

class ExercisePageViewController: UIPageViewController {

    var coreDataStack = CoreDataStack.sharedInstance
//    var muscleGroup: MuscleGroup!
    var mixlistName = String()
    var exercises = [Exercise]()
    var pageCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        title = mixlistName.uppercaseString

        view.backgroundColor = UIColor.whiteColor()

        setViewControllers([exerciseForPage(0)], direction: .Forward, animated: false, completion: nil)
        dataSource = self
    }

    private func exerciseForPage(inPage: Int) -> ExerciseViewController {
        let exerciseVC = storyboard!.instantiateViewControllerWithIdentifier("ExerciseViewController") as! ExerciseViewController
        let page = min(max(0, inPage), pageCount - 1)
        exerciseVC.page = page
        exerciseVC.exercise = exercises[page]
        

        return exerciseVC
    }
    
    @IBAction func onCloseButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
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

extension ExercisePageViewController: UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let currentExercisePage = viewController as? ExerciseViewController {
            if currentExercisePage.page < pageCount - 1 {
                return exerciseForPage(currentExercisePage.page + 1)
            }
        }
        return nil
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let currentExercisePage = viewController as? ExerciseViewController {
            if currentExercisePage.page > 0 {
                return exerciseForPage(currentExercisePage.page - 1)
            }
        }
        return nil
    }

}



















