//
//  FavouriteStationPresenter.swift
//  MyTravelHelper
//
//  Created by Jaswanth Pereira on 17/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

class FavouriteStationPresenter: ViewToFavouriteStationPresenterProtocol {
    var view: PresenterToFavouriteStationViewProtocol?
    
    weak var interactor: PresenterToFavouriteStationInteractorProtocol?
    
    weak var router: PresenterToFavouriteStationRouterProtocol?
    
    func fetchallStations() {
        
    }
    
    func stationTapped(station: Station) {
        
    }
    
    
}

extension FavouriteStationPresenter: InteractorToFavouriteStationPresenterProtocol {
    func favouriteStation(_ station: Station) {
        
    }
    
}
