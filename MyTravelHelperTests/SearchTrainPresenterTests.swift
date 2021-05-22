//
//  SearchTrainPresenterTests.swift
//  MyTravelHelperTests
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper
import XMLParsing

class SearchTrainPresenterTests: XCTestCase {
    var presenter: SearchTrainPresenter!
    var view = SearchTrainMockView()
    var interactor = SearchTrainInteractorMock()
    
    override func setUp() {
      presenter = SearchTrainPresenter()
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
    }

    func testfetchallStations() {
        presenter.fetchallStations()

        XCTAssertTrue(view.isSaveFetchedStatinsCalled)
    }

    override func tearDown() {
        presenter = nil
    }
}


class SearchTrainMockView:PresenterToViewProtocol {
    var isSaveFetchedStatinsCalled = false

    func saveFetchedStations(stations: [Station]?) {
        isSaveFetchedStatinsCalled = true
    }

    func showInvalidSourceOrDestinationAlert() {

    }
    
    func updateLatestTrainList(trainsList: [StationTrain]) {

    }
    
    func showNoTrainsFoundAlert() {

    }
    
    func showNoTrainAvailbilityFromSource() {

    }
    
    func showNoInterNetAvailabilityMessage() {

    }
}

class SearchTrainInteractorMock:PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?

    func fetchallStations() {
        let station = Station(desc: "Belfast Central", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228)
        presenter?.stationListFetched(list: [station])
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {

    }
}

class SearchTrainInteractorTests: XCTestCase {
    
    var searchTrainInteractor: SearchTrainInteractor!
    var presenter: SearchTrainPresenter!
    var view = SearchTrainMockView()
    
    override func setUp() {
        searchTrainInteractor = SearchTrainInteractor()
        presenter = SearchTrainPresenter()
        searchTrainInteractor.presenter = presenter
        presenter.view = view
        presenter.interactor = searchTrainInteractor
    }

    func testfetchallStations() {
        let expectation = self.expectation(description: "All stations are fetched")
        searchTrainInteractor.fetchallStations()
     searchTrainInteractor.expectation = expectation
        waitForExpectations(timeout: 30, handler: nil)
    }

    override func tearDown() {
        searchTrainInteractor = nil
    }
}

class SearchTrainInteractor: PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?
    var expectation: XCTestExpectation!

    func fetchallStations() {
        let urlString = "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML"
        APIClient.shared.fetchResponse(with: URLRequest(url: URL(string: urlString)!)) { (response) in
            let station = try? XMLDecoder().decode(Stations.self, from: response!)
            self.presenter!.stationListFetched(list: station?.stationsList ?? [])
            self.expectation.fulfill()
        }
    }
    
    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        
    }
    
    
}

extension SearchTrainInteractor: InteractorToPresenterProtocol {
    public func stationListFetched(list: [Station]) {
    }
    
    public func fetchedTrainsList(trainsList: [StationTrain]?) {
    }
    
    public func showNoTrainAvailbilityFromSource() {
        
    }
    
    public func showNoInterNetAvailabilityMessage() {
        
    }
    
    
}
