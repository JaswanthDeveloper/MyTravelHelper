//
//  FavouriteStationViewController.swift
//  MyTravelHelper
//
//  Created by Jaswanth Pereira on 16/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import UIKit

enum StationType {
    case from
    case to
}
protocol FavouriteStationDelegate: class {
    func onCancel()
    func onSlection(_ station: Station)
}

struct FavouriteStationDataSource {
    var stationsList: [Station] = [Station]()
    var selectedStation: Station?
    
    init(stationsList: [Station], selectedStation: Station?) {
        self.stationsList = stationsList
        self.selectedStation = selectedStation
    }
}

class FavouriteStationViewController: UIViewController {

    @IBOutlet weak var stationListTableView: UITableView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var alertLabel: UILabel!

    weak var delegate: FavouriteStationDelegate?
    private var stationsList: [Station] {
        return favouriteStationDataSource?.stationsList ?? []
    }
    private var selectedStation: Station? {
        return favouriteStationDataSource?.selectedStation
    }
    var favouriteStationDataSource: FavouriteStationDataSource?
    weak var presenter: ViewToFavouriteStationPresenterProtocol?
    
    deinit {
        print("deinit - FavouriteStationViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        holderView?.layer.borderWidth = 0.4
        holderView?.layer.cornerRadius = 20
        holderView?.layer.borderColor = UIColor.black.cgColor
        holderView.clipsToBounds = true
        alertLabel?.isHidden = !stationsList.isEmpty
    }
    
    func configureTableView() {
        stationListTableView?.dataSource = self
        stationListTableView?.delegate = self
        stationListTableView?.register(UINib(nibName: "FavouriteStationTableViewCell", bundle: nil), forCellReuseIdentifier: "FavouriteStationTableViewCell")
    }
    
    // MARK: - Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        delegate?.onCancel()
    }
}

extension FavouriteStationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favouriteStationCell = tableView.dequeueReusableCell(withIdentifier: "FavouriteStationTableViewCell", for: indexPath) as! FavouriteStationTableViewCell
        let station = stationsList[indexPath.row]
        favouriteStationCell.titleLabel?.text = station.stationDesc
        return favouriteStationCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stationsList[indexPath.row]
        delegate?.onSlection(station)
    }
}

extension FavouriteStationViewController: PresenterToFavouriteStationViewProtocol {
}
