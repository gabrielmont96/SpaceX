//
//  HomeViewModelTests.swift
//  SpaceXTests
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 25/01/22.
//

import XCTest
@testable import SpaceX

class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var executor: ExecutorMock!
    
    let infoDataExpectation = XCTestExpectation(description: "waiting for info request")
    let launchesDataExpectation = XCTestExpectation(description: "waiting for launch request")
    let errorExpectation = XCTestExpectation(description: "waiting for request error")
    let openDetailExpectation = XCTestExpectation(description: "waiting for open detail delegate")
    
    var infoText: String?
    var networkError: NetworkError?
    
    override func setUp() {
        executor = ExecutorMock()
        let service = NetworkService<HomeAPI>()
        service.executor = executor
        viewModel = HomeViewModel(service: service)
        viewModel.viewDelegate = self
        viewModel.coordinatorDelegate = self
    }
    
    override func tearDown() {
        viewModel = nil
        executor = nil
        infoText = nil
        networkError = nil
    }
    
    func testInfoDataWithSuccess() {
        let expectedText = "SpaceX was founded by Elon Musk in 2002. It has now 7000 employees, " +
            "3 launch sites, and is valued at USD $10,000.00."
        
        // Given
        let data = """
        {
            "name": "SpaceX",
            "founder": "Elon Musk",
            "founded": 2002,
            "employees": 7000,
            "launch_sites": 3,
            "valuation": 10000
         }
        """.data(using: .utf8)
        executor.mockedData = data
        
        // When
        viewModel.fetchInfo()
        
        wait(for: [infoDataExpectation], timeout: 2)
        
        // Then
        XCTAssertNil(networkError)
        XCTAssertEqual(infoText, expectedText)
    }
    
    func testInfoDataWithAPIError() {
        let errorMessage = "test error"
        
        // Given
        executor.mockedData = errorMessage.data(using: .utf8)
        executor.mockedStatusCode = 500
        
        // When
        viewModel.fetchInfo()
        
        wait(for: [errorExpectation], timeout: 2)
        
        // Then
        XCTAssertNil(infoText)
        XCTAssertNotNil(networkError)
        if case let .api(statusCode, message) = networkError {
            XCTAssertEqual(statusCode, 500)
            XCTAssertEqual(message, errorMessage)
        } else {
            XCTFail("The error should be API")
        }
    }
    
    func testLaunchesDataWithSuccess() {
        let missionName = "FalconSat"
        let launchYear = "2006"
        let launchDate = 1143239400
        let rocketName = "Falcon 1"
        let rocketType = "Merlin A"
        let smallImagePath = "smallImage"
        let largeImagePath = "largeImage"
        let wikipediaLink = "wikipediaLink"
        let videoLink = "videoLink"
        let articleLink = "articleLink"
        
        // Given
        let data =
        """
        [
            {
                "mission_name": "FalconSat",
                "launch_year": "2006",
                "launch_date_unix": 1143239400,
                "rocket": {
                    "rocket_name": "Falcon 1",
                    "rocket_type": "Merlin A"
                },
                "launch_success": false,
                "links": {
                    "mission_patch": "largeImage",
                    "mission_patch_small": "smallImage",
                    "article_link": "articleLink",
                    "wikipedia": "wikipediaLink",
                    "video_link": "videoLink"
                }
            }
        ]
        """.data(using: .utf8)
        executor.mockedData = data
        
        // When
        viewModel.fetchLaunches()
        
        wait(for: [launchesDataExpectation], timeout: 2)
        
        // Then
        XCTAssertNil(networkError)
        XCTAssertEqual(viewModel.getLaunchesSize(), 1)
        XCTAssertEqual(viewModel.getLaunche(for: 0).missionName, missionName)
        XCTAssertEqual(viewModel.getLaunche(for: 0).launchYear, launchYear)
        XCTAssertEqual(viewModel.getLaunche(for: 0).launchDate, launchDate)
        XCTAssertEqual(viewModel.getLaunche(for: 0).rocket.rocketName, rocketName)
        XCTAssertEqual(viewModel.getLaunche(for: 0).rocket.rocketType, rocketType)
        XCTAssertFalse(viewModel.getLaunche(for: 0).launchSuccess ?? true)
        XCTAssertEqual(viewModel.getLaunche(for: 0).links.smallImage, smallImagePath)
        XCTAssertEqual(viewModel.getLaunche(for: 0).links.largeImage, largeImagePath)
        XCTAssertEqual(viewModel.getLaunche(for: 0).links.wikipediaLink, wikipediaLink)
        XCTAssertEqual(viewModel.getLaunche(for: 0).links.videoLink, videoLink)
        XCTAssertEqual(viewModel.getLaunche(for: 0).links.articleLink, articleLink)
    }

    func testLaunchesDataWithAPIError() {
        let errorMessage = "test error"
        
        // Given
        executor.mockedData = errorMessage.data(using: .utf8)
        executor.mockedStatusCode = 404
        
        // When
        viewModel.fetchLaunches()
        
        wait(for: [errorExpectation], timeout: 2)
        
        // Then
        XCTAssertNotNil(networkError)
        XCTAssertEqual(viewModel.getLaunchesSize(), 0)
        if case let .api(statusCode, message) = networkError {
            XCTAssertEqual(statusCode, 404)
            XCTAssertEqual(message, errorMessage)
        } else {
            XCTFail("The error should be API")
        }
    }
    
    func testOpenDetail() {
        // Given
        let data =
        """
        [
            {
                "mission_name": "FalconSat",
                "launch_year": "2006",
                "launch_date_unix": 1143239400,
                "rocket": {
                    "rocket_name": "Falcon 1",
                    "rocket_type": "Merlin A"
                },
                "launch_success": false,
                "links": {
                    "mission_patch": "largeImage",
                    "mission_patch_small": "smallImage",
                    "article_link": "articleLink",
                    "wikipedia": "wikipediaLink",
                    "video_link": "videoLink"
                }
            }
        ]
        """.data(using: .utf8)
        executor.mockedData = data
        
        // When // Then
        viewModel.fetchLaunches()
        viewModel.openDetails(index: 0)
        wait(for: [launchesDataExpectation, openDetailExpectation], timeout: 2)
        
    }
}

extension HomeViewModelTests: HomeViewModelViewDelegate {
    func loadedInfoData(viewModel: HomeViewModel, infoText: String) {
        self.infoText = infoText
        infoDataExpectation.fulfill()
    }
    
    func loadedLaunchedData(viewModel: HomeViewModel) {
        launchesDataExpectation.fulfill()
    }
    
    func loadedWithFailure(viewModel: HomeViewModel, networkError: NetworkError) {
        self.networkError = networkError
        errorExpectation.fulfill()
    }
}

extension HomeViewModelTests: HomeViewModelCoordinatorDelegate {
    func openDetails(viewModel: HomeViewModel, model: LaunchesModel) {
        openDetailExpectation.fulfill()
    }
}
