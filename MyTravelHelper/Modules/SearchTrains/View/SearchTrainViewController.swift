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
    
    var stationsList:[Station] = [Station]()
    var trains:[StationTrain] = [StationTrain]()
    var presenter:ViewToPresenterProtocol?
    var dropDown = DropDown()
    var transitPoints:(source:String,destination:String) = ("","")

    override func viewDidLoad() {
        super.viewDidLoad()
        trainsListTable.isHidden = true
        initialSetup()
    }
    
    private func initialSetup() {
        searchButton?.isEnabled = false
        
        let favouriteStationView = Bundle.main.loadNibNamed("FavouriteStationView", owner: nil, options: nil)?.first as! FavouriteStationView
        favouriteStationView.delegate = self
        favouriteStationHolderView.addSubview(favouriteStationView)
        favouriteStationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: favouriteStationView, attribute: .top, relatedBy: .equal, toItem: favouriteStationHolderView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: favouriteStationView, attribute: .bottom, relatedBy: .equal, toItem: favouriteStationHolderView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: favouriteStationView, attribute: .left, relatedBy: .equal, toItem: favouriteStationHolderView, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: favouriteStationView, attribute: .right, relatedBy: .equal, toItem: favouriteStationHolderView, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
    }

    func updateUI(textField: UITextField, updatedText: String) {
        searchButton?.isEnabled = !((sourceTxtField == sourceTxtField ? destinationTextField : sourceTxtField).text?.isEmpty ?? false || updatedText.isEmpty)
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
            updateUI(textField: textField, updatedText: desiredSearchText)
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
    func segemntControlActionFor(_favouriteStationType: FavouriteStationType) {
        
    }
    
    func buttonActionFor(_ avouriteStationActionType: FavouriteStationActionType) {
        guard let navigationController = navigationController else { return }
        presenter?.showFavouriteStationController(navigationController: navigationController)
    }
    
    
}
