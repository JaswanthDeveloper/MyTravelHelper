//
//  SearchTrainProtocols.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

protocol ViewToPresenterProtocol: class{
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    func fetchallStations()
    func showFavouriteStationController(navigationController:UINavigationController, dataSource: FavouriteStationDataSource)
    func searchTapped(source:String,destination:String)
    func dismissFavouriteStationController(navigationController:UINavigationController)
}

protocol PresenterToViewProtocol: class{
    func saveFetchedStations(stations:[Station]?)
    func showInvalidSourceOrDestinationAlert()
    func updateLatestTrainList(trainsList: [StationTrain])
    func showNoTrainsFoundAlert()
    func showNoTrainAvailbilityFromSource()
    func showNoInterNetAvailabilityMessage()
}

protocol PresenterToRouterProtocol: class {
    static func createModule()-> SearchTrainViewController
    func pushToFavouriteStationScreen(navigationController:UINavigationController, dataSource: FavouriteStationDataSource)
    func popFavouriteStationScreen(navigationController:UINavigationController)
}

protocol PresenterToFavouriteStationRouterProtocol: class {
    static func createModule()-> FavouriteStationViewController
}

protocol PresenterToInteractorProtocol: class {
    var presenter:InteractorToPresenterProtocol? {get set}
    func fetchallStations()
    func fetchTrainsFromSource(sourceCode:String,destinationCode:String)
}

protocol InteractorToPresenterProtocol: class {
    func stationListFetched(list:[Station])
    func fetchedTrainsList(trainsList:[StationTrain]?)
    func showNoTrainAvailbilityFromSource()
    func showNoInterNetAvailabilityMessage()
}

protocol InteractorToFavouriteStationPresenterProtocol: class {
    func favouriteStation(_ station: Station)
 }



protocol ViewToFavouriteStationPresenterProtocol: class{
    var view: PresenterToFavouriteStationViewProtocol? {get set}
    var interactor: PresenterToFavouriteStationInteractorProtocol? {get set}
    var router: PresenterToFavouriteStationRouterProtocol? {get set}
    func fetchallStations()
    func stationTapped(station: Station)
}


protocol PresenterToFavouriteStationViewProtocol: class{

}

protocol PresenterToFavouriteStationInteractorProtocol: class {
    var presenter:InteractorToFavouriteStationPresenterProtocol? {get set}

}

