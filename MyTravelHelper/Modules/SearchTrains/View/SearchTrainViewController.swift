//
//  SearchTrainViewController.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit
import SwiftSpinner
import DropDown

class SearchTrainViewController: UIViewController {
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var sourceTxtField: UITextField!
    @IBOutlet weak var trainsListTable: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var favouriteStationHolderView: UIView!
    
    var favouriteStationView: FavouriteStationView!
    var stationsList:[Station] = [Station]()
    var trains:[StationTrain] = [StationTrain]()
    var presenter:ViewToPresenterProtocol?
    var dropDown = DropDown()
    var transitPoints:(source:String,destination:String) = ("","")
    var favouriteStation: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trainsListTable.isHidden = true
        initialSetup()
    }
    
    private func initialSetup() {        
        let favouriteStationView = Bundle.main.loadNibNamed("FavouriteStationView", owner: nil, options: nil)?.first as! FavouriteStationView
        favouriteStationView.delegate = self
        favouriteStationHolderView.addSubview(favouriteStationView)
        favouriteStationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: favouriteStationView, attribute: .top, relatedBy: .equal, toItem: favouriteStationHolderView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: favouriteStationView, attribute: .bottom, relatedBy: .equal, toItem: favouriteStationHolderView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: favouriteStationView, attribute: .left, relatedBy: .equal, toItem: favouriteStationHolderView, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: favouriteStationView, attribute: .right, relatedBy: .equal, toItem: favouriteStationHolderView, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        self.favouriteStationView = favouriteStationView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if stationsList.count == 0 {
            SwiftSpinner.useContainerView(view)
            SwiftSpinner.show("Please wait loading station list ....")
            presenter?.fetchallStations()
        }
    }

    @IBAction func searchTrainsTapped(_ sender: Any) {
        view.endEditing(true)
        guard !(sourceTxtField.text?.isEmpty ?? false) && !(destinationTextField.text?.isEmpty ?? false) else {
            showAlertMessage("Please select both Source and Destination stations.")
            return
        }
        showProgressIndicator(view: self.view)
        presenter?.searchTapped(source: transitPoints.source, destination: transitPoints.destination)
    }
}

extension SearchTrainViewController:PresenterToViewProtocol {
    func showNoInterNetAvailabilityMessage() {
        trainsListTable.isHidden = true
        hideProgressIndicator(view: self.view)
        showAlert(title: "No Internet", message: "Please Check you internet connection and try again", actionTitle: "Okay")
    }

    func showNoTrainAvailbilityFromSource() {
        trainsListTable.isHidden = true
        hideProgressIndicator(view: self.view)
        showAlert(title: "No Trains", message: "Sorry No trains arriving source station in another 90 mins", actionTitle: "Okay")
    }

    func updateLatestTrainList(trainsList: [StationTrain]) {
        hideProgressIndicator(view: self.view)
        trains = trainsList
        trainsListTable.isHidden = false
        trainsListTable.reloadData()
    }

    func showNoTrainsFoundAlert() {
        trainsListTable.isHidden = true
        hideProgressIndicator(view: self.view)
        trainsListTable.isHidden = true
        showAlert(title: "No Trains", message: "Sorry No trains Found from source to destination in another 90 mins", actionTitle: "Okay")
    }

    func showAlert(title:String,message:String,actionTitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showInvalidSourceOrDestinationAlert() {
        trainsListTable.isHidden = true
        hideProgressIndicator(view: self.view)
        showAlert(title: "Invalid Source/Destination", message: "Invalid Source or Destination Station names Please Check", actionTitle: "Okay")
    }

    func saveFetchedStations(stations: [Station]?) {
        if let _stations = stations {
          self.stationsList = _stations
        }
        SwiftSpinner.hide()
    }
    
    private func dismissFavouriteStationViewController() {
        guard let navigationController = navigationController else { return }
        presenter?.dismissFavouriteStationController(navigationController: navigationController)
    }
}

extension SearchTrainViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dropDown = DropDown()
        dropDown.anchorView = textField
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = stationsList.map {$0.stationDesc}
        dropDown.selectionAction = { (index: Int, item: String) in
            if textField == self.sourceTxtField {
                self.transitPoints.source = item
            }else {
                self.transitPoints.destination = item
            }
            textField.text = item
        }
        dropDown.show()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dropDown.hide()
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let inputedText = textField.text {
            var desiredSearchText = inputedText
            if string != "\n" && !string.isEmpty{
                desiredSearchText = desiredSearchText + string
            }else {
                desiredSearchText = String(desiredSearchText.dropLast())
            }
            dropDown.dataSource = stationsList.map {$0.stationDesc}
            dropDown.show()
            dropDown.reloadAllComponents()
        }
        return true
    }
}

extension SearchTrainViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trains.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "train", for: indexPath) as! TrainInfoCell
        let train = trains[indexPath.row]
        cell.trainCode.text = train.trainCode
        cell.souceInfoLabel.text = train.stationFullName
        cell.sourceTimeLabel.text = train.expDeparture
        if let _destinationDetails = train.destinationDetails {
            cell.destinationInfoLabel.text = _destinationDetails.locationFullName
            cell.destinationTimeLabel.text = _destinationDetails.expDeparture
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}

extension SearchTrainViewController: FavouriteStationViewDelegate {
    func segemntControlActionFor(_ favouriteStationType: FavouriteStationType) {
        switch favouriteStationType {
        case .source:
            sourceTxtField?.text = favouriteStation?.stationDesc
        case .destination:
            destinationTextField?.text = favouriteStation?.stationDesc
        }
    }   
    
    func buttonActionFor(_ favouriteStationActionType: FavouriteStationActionType) {
        guard let navigationController = navigationController else { return }
        switch favouriteStationActionType {
        case .add:
            /*
            // uncomment to add test stations
    
            let station = Station(desc: "Belfast Central", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228)
            let station2 = Station(desc: "Delhi", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228)
            let station3 = Station(desc: "Bangalore", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228)
            stationsList.append(contentsOf: [station, station2, station3])
           */
        let favouriteStationDataSource = FavouriteStationDataSource(stationsList: stationsList, selectedStation: favouriteStation)
            presenter?.showFavouriteStationController(navigationController: navigationController, dataSource: favouriteStationDataSource)
        default:
            favouriteStationView?.configureWith(nil)
        }
    }
}

extension SearchTrainViewController: FavouriteStationDelegate {
    func onCancel() {
        dismissFavouriteStationViewController()
    }
    
    func onSlection(_ station: Station) {
        dismissFavouriteStationViewController()
        favouriteStation = station
        favouriteStationView.configureWith(station)
    }
}
