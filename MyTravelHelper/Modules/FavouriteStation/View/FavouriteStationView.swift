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
    func segemntControlActionFor(_ favouriteStationType: FavouriteStationType)
    func buttonActionFor(_ favouriteStationActionType: FavouriteStationActionType)
}

class FavouriteStationView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    weak var delegate: FavouriteStationViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentControl?.isSelected = false
        segmentControl?.isEnabled = false
        segmentControl?.alpha = 0.3
        segmentControl?.selectedSegmentIndex = -1
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        let favouriteStationActionType: FavouriteStationActionType =  sender.isSelected ? .delete : .add
        delegate?.buttonActionFor(favouriteStationActionType)
    }
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        guard let favouriteStationType = FavouriteStationType(rawValue: sender.selectedSegmentIndex) else { return }
        delegate?.segemntControlActionFor(favouriteStationType)
    }
    
    func configureWith(_ station: Station?) {
        let hasStation = station != nil
        titleLabel?.text = hasStation ? "\(station?.stationDesc ?? "-")" : "-"
        actionButton.isSelected = hasStation
        segmentControl.isEnabled = hasStation
        segmentControl?.alpha = hasStation ? 1 : 0.3
        segmentControl?.selectedSegmentIndex = -1
    }
}
