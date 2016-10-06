//
//  TrainingZoneInfoViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 10/6/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit

class TrainingZoneInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!

    var parentView: UIViewController?
    var bgView = UIView()
    var trainingZonesInfo = [(trainingZone: String, info: String)]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Round corners of contentView
        contentView.layer.cornerRadius = 18.0

        // Add border to top of dismissButton to separate it from the view
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: dismissButton.frame.size.width, height: 0.5))
        lineView.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        dismissButton.addSubview(lineView)

        // Training zones info
        trainingZonesInfo = [
            (trainingZone: "Hypertrophy", info: "The sets, reps and rest time combinations are designed to increase muscle size and promote muscle growth. Use these exercise volumes to help pack on size."),
            (trainingZone: "Power", info: "The sets, reps and rest time combinations are designed to increase explosiveness."),
            (trainingZone: "Strength", info: "The sets, reps and rest time combinations are designed to increase muscle strength."),
            (trainingZone: "Endurance", info: "The sets, reps and rest time combinations are designed to increase muscle endurance. This means training your muscles to do more reps, and function at a certain capacity for longer amounts of time.")
        ]

        instantiateTransparentBackGroundView()

        // Remove empty table view cells
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
//        tableView.sizeToFit()
    }

    func instantiateTransparentBackGroundView() {
        if let viewController = parentView {
            bgView = UIView(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.width, height: viewController.view.frame.height))
            bgView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            bgView.alpha = 0.0
            viewController.view.addSubview(bgView)
            UIView.animate(withDuration: 0.3, animations: {
                self.bgView.alpha = 1
            })
        }
    }
    
    @IBAction func onDismissButtonPressed(_ sender: UIButton) {

        UIView.animate(withDuration: 0.3, animations: { 
            self.bgView.alpha = 0.0
            }) { (Bool) in
                self.bgView.removeFromSuperview()
        }
        self.dismiss(animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TrainingZoneInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainingZonesInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrainingZoneInfoCell", for: indexPath) as? TrainingZoneInfoTableViewCell else {
            fatalError("Cell is not a TrainingZoneInfoTableViewCell")
        }

        let trainingZone = trainingZonesInfo[indexPath.row]
        cell.trainingZoneLabel.text = trainingZone.trainingZone
        cell.trainingZoneDescriptionLabel.text = trainingZone.info

        if trainingZone.trainingZone == "Hypertrophy" {
            cell.trainingZoneLabel.textColor = UIColor(red: 139.0/255.0, green: 195.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        } else if trainingZone.trainingZone == "Endurance" {
            cell.trainingZoneLabel.textColor = UIColor(red: 0.0, green: 145.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        } else if trainingZone.trainingZone == "Power" {
            cell.trainingZoneLabel.textColor = ColorWheel.redColor()
        } else {
            cell.trainingZoneLabel.textColor = UIColor(red: 239.0/255.0, green: 108.0/255.0, blue: 0.0, alpha: 1.0)
        }

        return cell
    }
}
