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

        // Set font weight for Save button
        saveButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold), NSForegroundColorAttributeName: ColorWheel.leadColor()], for: .normal)

        if mixlist != nil {
            self.mixlistTitleTextField.text = mixlist?.name
        }

        mixlistTitleTextField.delegate = self

        if mixlistTitleTextField.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }

        mixlistTitleTextField.becomeFirstResponder()
    }

    @IBAction func onSaveButtonPressed(_ sender: UIBarButtonItem) {

        if mixlist != nil {
            mixlist?.setValue(self.mixlistTitleTextField.text, forKey: "name")

            coreDataStack.saveMainContext()

            mixlistTitleTextField.resignFirstResponder()
            self.performSegue(withIdentifier: "UnwindToMixlistDetail", sender: self)
        } else {
            guard let entity = NSEntityDescription.entity(forEntityName: "UserCreatedMixlist", in: coreDataStack.managedObjectContext) else {
                fatalError("Could not find entity descriptions!")
            }

            let newMixlist = UserCreatedMixlist(entity: entity, insertInto: coreDataStack.managedObjectContext)
            if let name = self.mixlistTitleTextField.text {
                newMixlist.name = name
            }

            coreDataStack.saveMainContext()

            mixlistTitleTextField.resignFirstResponder()
            self.performSegue(withIdentifier: "UnwindToMixlists", sender: self)
        }
    }

    @IBAction func onCancelButtonPressed(_ sender: UIBarButtonItem) {
        mixlistTitleTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
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
    @IBAction func onTextFieldEditingChanged(_ sender: UITextField) {
        if mixlistTitleTextField.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        return (mixlistTitleTextField?.text?.utf16.count ?? 0) + string.utf16.count - range.length <= maxLength
    }
}












