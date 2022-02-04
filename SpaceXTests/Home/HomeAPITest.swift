//
//  HomeAPITest.swift
//  SpaceXTests
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 25/01/22.
//

import Foundation
import XCTest
@testable import SpaceX

class HomeAPITests: XCTestCase {
    func testInfoAPI() {
        let info = HomeAPI.info
        
        XCTAssertEqual(info.baseURL, "https://api.spacexdata.com/")
        XCTAssertEqual(info.method, .get)
        XCTAssertEqual(info.headers, [:])
        XCTAssertEqual(info.path, "v3/info")
    }
    
    func testLaunchesAPI() {
        let launches = HomeAPI.launches
        
        XCTAssertEqual(launches.baseURL, "https://api.spacexdata.com/")
        XCTAssertEqual(launches.method, .get)
        XCTAssertEqual(launches.headers, [:])
        XCTAssertEqual(launches.path, "v3/launches")
    }
}
