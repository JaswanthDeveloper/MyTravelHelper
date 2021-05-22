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
    func pushToFavouriteStationScreen(navigationConroller: UINavigationController) {
        let favouriteStationModule = FavouriteStationRouter.createModule()
        navigationConroller.pushViewController(favouriteStationModule,animated: true)
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
    
    func pushToMovieScreen(navigationConroller navigationController:UINavigationController) {
        let movieModue = FavouriteStationRouter.createModule()
        movieModue.modalPresentationStyle = .overCurrentContext
        navigationController.present(movieModue, animated: true, completion: nil)
        
    }
}
