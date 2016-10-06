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

        title = mixlistName.uppercased()
        delegate = self

        view.backgroundColor = UIColor.white

        setViewControllers([exerciseForPage(0)], direction: .forward, animated: false, completion: nil)
        dataSource = self
    }

    fileprivate func exerciseForPage(_ inPage: Int) -> ExerciseViewController {
        let exerciseVC = storyboard!.instantiateViewController(withIdentifier: "ExerciseViewController") as! ExerciseViewController
        let page = min(max(0, inPage), pageCount - 1)
        exerciseVC.page = page
        exerciseVC.exercise = exercises[page]
        

        return exerciseVC
    }
    
    @IBAction func onCloseButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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

extension ExercisePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentExercisePage = viewController as? ExerciseViewController {
            if currentExercisePage.page < pageCount - 1 {
                return exerciseForPage(currentExercisePage.page + 1)
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentExercisePage = viewController as? ExerciseViewController {
            if currentExercisePage.page > 0 {
                return exerciseForPage(currentExercisePage.page - 1)
            }
        }
        return nil
    }

//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if #available(iOS 10.0, *) {
//            let generator = UISelectionFeedbackGenerator()
//            generator.selectionChanged()
//        } else {
//            // Fallback on earlier versions
//        }
//    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
//            generator.selectionChanged()
            generator.impactOccurred()
        } else {
            // Fallback on earlier versions
        }
    }

}



















