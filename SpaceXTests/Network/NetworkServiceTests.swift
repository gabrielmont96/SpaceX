//
//  NetworkServiceTests.swift
//  SpaceXTests
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 25/01/22.
//

import Foundation
import XCTest
@testable import SpaceX

class NetworkServiceTests: XCTestCase {
    var service: NetworkService<TestAPI>!
    var executor: ExecutorMock!
    
    override func setUp() {
        executor = ExecutorMock()
        service = NetworkService<TestAPI>()
        service.executor = executor
    }
    
    override func tearDown() {
        executor = nil
        service = nil
    }
    
    func testInvalidURL() {
        let expectation = XCTestExpectation(description: "waiting for completion")
        
        service.request(target: .invalid, expecting: TestModel.self) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
            case .success:
                XCTFail("This test should be error")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testInvalidData() {
        let expectation = XCTestExpectation(description: "waiting for completion")
        
        executor.mockedData = nil
        
        service.request(target: .test, expecting: TestModel.self) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidData)
            case .success:
                XCTFail("This test should be error")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testParseError() {
        let expectation = XCTestExpectation(description: "waiting for completion")
        
        executor.mockedData = "parseError".data(using: .utf8)
        
        service.request(target: .test, expecting: TestModel.self) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .parseError(NSError()))
            case .success:
                XCTFail("This test should be error")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testAPIError() {
        let expectation = XCTestExpectation(description: "waiting for completion")
        
        executor.mockedStatusCode = 401
        
        service.request(target: .test, expecting: TestModel.self) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .api(statusCode: 401, message: nil))
            case .success:
                XCTFail("This test should be error")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testParseSuccess() {
        let expectation = XCTestExpectation(description: "waiting for completion")
        
        executor.mockedData = "{ \"name\": \"Gabriel\" }".data(using: .utf8)
        
        service.request(target: .test, expecting: TestModel.self) { result in
            switch result {
            case .failure:
                XCTFail("This test should be success")
            case .success(let model):
                XCTAssertEqual(model.name, "Gabriel")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}

private struct TestModel: Codable {
    let name: String
}
