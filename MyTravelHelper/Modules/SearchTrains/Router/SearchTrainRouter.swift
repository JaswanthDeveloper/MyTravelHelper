//
//  SearchTrainRouter.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

protocol BaseRouterProtocol {
    static func storyboardFor(_ name: String) -> UIStoryboard
}

extension BaseRouterProtocol {
    static func storyboardFor(_ name: String) -> UIStoryboard {
        return UIStoryboard(name: name,bundle: Bundle.main)
    }
}

class SearchTrainRouter: BaseRouterProtocol, PresenterToRouterProtocol {
    func popFavouriteStationScreen(navigationController: UINavigationController) {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func pushToFavouriteStationScreen(navigationController: UINavigationController, dataSource: FavouriteStationDataSource) {
        let favouriteStationModule = FavouriteStationRouter.createModule()
        favouriteStationModule.delegate = navigationController.topViewController as? SearchTrainViewController
        favouriteStationModule.favouriteStationDataSource = dataSource
        favouriteStationModule.modalPresentationStyle = .overCurrentContext
        navigationController.present(favouriteStationModule, animated: true, completion: nil)
    }
    
    static func createModule() -> SearchTrainViewController {
        let view = storyboardFor(Storyboard.main).instantiateViewController(withIdentifier: "searchTrain") as! SearchTrainViewController
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = SearchTrainPresenter()
        let interactor: PresenterToInteractorProtocol = SearchTrainInteractor()
        let router:PresenterToRouterProtocol = SearchTrainRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}
