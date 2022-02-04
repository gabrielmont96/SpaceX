//
//  ExecutorMock.swift
//  SpaceXTests
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 25/01/22.
//

import Foundation
@testable import SpaceX

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    
    func resume() { }
}

class ExecutorMock: Executor {
    var mockedData: Data?
    var mockedError: Error?
    var mockedStatusCode = 200
    var mockedResponseHeaders: [String: String]? = [:]
    
    func perform(with request: URLRequest,
                 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let urlResponse = HTTPURLResponse(url: request.url ?? URL(fileURLWithPath: ""),
                                          statusCode: mockedStatusCode,
                                          httpVersion: nil,
                                          headerFields: mockedResponseHeaders)
        
        completionHandler(mockedData, urlResponse, mockedError)
        return URLSessionDataTaskMock()
    }
}
