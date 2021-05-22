//
//  FavouriteStationRouter.swift
//  MyTravelHelper
//
//  Created by Jaswanth Pereira on 16/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

class FavouriteStationRouter: BaseRouterProtocol, PresenterToFavouriteStationRouterProtocol {
    static func createModule() -> FavouriteStationViewController {
        let view = storyboardFor(Storyboard.main).instantiateViewController(withIdentifier: "FavouriteStationViewController") as! FavouriteStationViewController
        let presenter: ViewToFavouriteStationPresenterProtocol & InteractorToFavouriteStationPresenterProtocol = FavouriteStationPresenter()
        let interactor: PresenterToFavouriteStationInteractorProtocol = FavouriteStationInterator()
        let router:PresenterToFavouriteStationRouterProtocol = FavouriteStationRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
