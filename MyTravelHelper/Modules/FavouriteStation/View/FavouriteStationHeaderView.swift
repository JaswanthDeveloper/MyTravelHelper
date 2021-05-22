//
//  FavouriteStationHeaderView.swift
//  MyTravelHelper
//
//  Created by Jaswanth Pereira on 12/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import UIKit

class FavouriteStationHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var stationTitleLabel: UILabel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
}
