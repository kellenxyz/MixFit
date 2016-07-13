//
//  NewMixlistViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/29/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit
import CoreData

class NewMixlistViewController: UIViewController {

    var coreDataStack = CoreDataStack.sharedInstance
    var mixlist: UserCreatedMixlist?
    var newTitle: String?

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var mixlistTitleTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = newTitle ?? "NEW MIXLIST"

        // Do any additional setup after loading the view.

        if mixlist != nil {
            self.mixlistTitleTextField.text = mixlist?.name
        }

        mixlistTitleTextField.delegate = self

        if mixlistTitleTextField.text == "" {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
        }

        mixlistTitleTextField.becomeFirstResponder()
    }

    @IBAction func onSaveButtonPressed(sender: UIBarButtonItem) {

        if mixlist != nil {
            mixlist?.setValue(self.mixlistTitleTextField.text, forKey: "name")

            coreDataStack.saveMainContext()

            mixlistTitleTextField.resignFirstResponder()
            self.performSegueWithIdentifier("UnwindToMixlistDetail", sender: self)
        } else {
            guard let entity = NSEntityDescription.entityForName("UserCreatedMixlist", inManagedObjectContext: coreDataStack.managedObjectContext) else {
                fatalError("Could not find entity descriptions!")
            }

            let newMixlist = UserCreatedMixlist(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
            if let name = self.mixlistTitleTextField.text {
                newMixlist.name = name
            }

            coreDataStack.saveMainContext()

            mixlistTitleTextField.resignFirstResponder()
            self.performSegueWithIdentifier("UnwindToMixlists", sender: self)
        }
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

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        return (mixlistTitleTextField?.text?.utf16.count ?? 0) + string.utf16.count - range.length <= maxLength
    }
}












