//
//  FavouriteStationView.swift
//  MyTravelHelper
//
//  Created by Jaswanth Pereira on 21/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import UIKit

enum FavouriteStationType: Int {
    case source = 0, destination
}
enum FavouriteStationActionType {
    case add, delete
}

protocol FavouriteStationViewDelegate: class {
    func segemntControlActionFor(_favouriteStationType: FavouriteStationType)
    func buttonActionFor(_ avouriteStationActionType: FavouriteStationActionType)
}

class FavouriteStationView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    weak var delegate: FavouriteStationViewDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        segmentControl?.isSelected = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let favouriteStationActionType: FavouriteStationActionType =  sender.isSelected ? .add : .delete
        delegate?.buttonActionFor(favouriteStationActionType)
    }
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        guard let favouriteStationType = FavouriteStationType(rawValue: sender.selectedSegmentIndex) else { return }
        delegate?.segemntControlActionFor(_favouriteStationType: favouriteStationType)
    }
}
