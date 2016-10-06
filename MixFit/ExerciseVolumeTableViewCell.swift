//
//  ExerciseVolumeTableViewCell.swift
//  MixFit
//
//  Created by Kellen Pierson on 10/5/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit

class ExerciseVolumeTableViewCell: UITableViewCell {

    @IBOutlet weak var trainingZoneLabel: UILabel!
    @IBOutlet weak var exerciseVolumeLabel: UILabel!
    @IBOutlet weak var trainingZoneLabelView: UIView!
    @IBOutlet weak var exerciseVolumeLabelView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        trainingZoneLabelView.layer.cornerRadius = 6
//        exerciseVolumeLabelView.layer.borderWidth = 1.0
//        exerciseVolumeLabelView.layer.borderColor = UIColor.gray.cgColor
//        exerciseVolumeLabelView.layer.cornerRadius = 6

//        let maskPath = UIBezierPath(roundedRect: self.exerciseVolumeLabelView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 6.0, height: 6.0))
//        let shape = CAShapeLayer()
//        shape.path = maskPath.cgPath
//        exerciseVolumeLabelView.layer.mask = shape
//
//        let borderLayer = CAShapeLayer()
//        borderLayer.frame = exerciseVolumeLabelView.bounds
//        borderLayer.path = maskPath.cgPath
//        borderLayer.lineWidth = 1.0
//        borderLayer.strokeColor = UIColor.gray.cgColor
//        borderLayer.fillColor = UIColor.clear.cgColor

//        exerciseVolumeLabelView.layer.addSublayer(borderLayer)

//        self.layoutSubviews()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
