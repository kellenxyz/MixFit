//
//  MuscleGroupTableViewCell.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/22/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit

class MuscleGroupTableViewCell: UITableViewCell {

//    @IBOutlet weak var mgCellImageView: CustomImageView!
    @IBOutlet weak var mgCellTextLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /*
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if highlighted {
            mgCellTextLabel.textColor = UIColor.whiteColor()
            backgroundColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        } else {
            mgCellTextLabel.textColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            backgroundColor = UIColor.whiteColor()
        }
    }
    */

}
