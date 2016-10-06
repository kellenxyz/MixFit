//
//  TrainingZoneInfoTableViewCell.swift
//  MixFit
//
//  Created by Kellen Pierson on 10/6/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit

class TrainingZoneInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trainingZoneLabel: UILabel!
    @IBOutlet weak var trainingZoneDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
