//
//  StationCell.swift
//  SFTransit
//
//  Created by Amie Kweon on 5/20/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

class StationCell: UITableViewCell {

    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lineBar: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setStation(station: Station) {
        stationName.text = station.name!
        //timeLabel.text = station.
        lineBar.backgroundColor = UIColor.createWithHex("#cc0000")
    }

}
