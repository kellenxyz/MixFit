//
//  NewMixlistViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/29/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit

class NewMixlistViewController: UIViewController {

    var coreDataStack: CoreDataStack!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var mixlistTitleTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "NEW MIXLIST"

        // Do any additional setup after loading the view.

        mixlistTitleTextField.delegate = self

        if mixlistTitleTextField.text == "" {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
        }

        mixlistTitleTextField.becomeFirstResponder()
    }

    @IBAction func onSaveButtonPressed(sender: UIBarButtonItem) {
        //Save mixlist into CoreData

        mixlistTitleTextField.resignFirstResponder()
        self.performSegueWithIdentifier("UnwindToMixlists", sender: self)
    }

    @IBAction func onCancelButtonPressed(sender: UIBarButtonItem) {
        mixlistTitleTextField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
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

extension NewMixlistViewController: UITextFieldDelegate {
    @IBAction func onTextFieldEditingChanged(sender: UITextField) {
        if mixlistTitleTextField.text == "" {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
        }
    }
}
