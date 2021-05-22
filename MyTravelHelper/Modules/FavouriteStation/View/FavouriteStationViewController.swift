//
//  FavouriteStationViewController.swift
//  MyTravelHelper
//
//  Created by Jaswanth Pereira on 16/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import UIKit

class FavouriteStationViewController: UIViewController {

    @IBOutlet weak var stationListTableView: UITableView!

    var stationsList:[Station] = [Station]()
    var presenter: ViewToFavouriteStationPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        // test station
        let station = Station(desc: "Belfast Central", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228)
        stationsList.append(station)
        configureTableView()
    }
    
    func configureTableView() {
        stationListTableView?.dataSource = self
        stationListTableView?.delegate = self
        stationListTableView?.register(UINib(nibName: "FavouriteStationTableViewCell", bundle: nil), forCellReuseIdentifier: "FavouriteStationTableViewCell")
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
}

extension FavouriteStationViewController: PresenterToFavouriteStationViewProtocol {
}
