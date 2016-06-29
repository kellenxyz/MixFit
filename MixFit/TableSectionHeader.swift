//
//  TableSectionHeader.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/27/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit

class TableSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        self.contentView.backgroundColor = UIColor.whiteColor()
//
//        let bottomBorder = CALayer()
//        bottomBorder.backgroundColor = UIColor.blueColor().CGColor
//        bottomBorder.frame = CGRectMake(0, -self.frame.height + 1, self.frame.width, 1.0)
//        self.layer.addSublayer(bottomBorder)

    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
