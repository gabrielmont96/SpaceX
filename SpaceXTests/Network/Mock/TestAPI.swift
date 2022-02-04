//
//  TestAPIMock.swift
//  SpaceXTests
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 25/01/22.
//

import Foundation
@testable import SpaceX

enum TestAPI {
    case test
    case invalid
}

extension TestAPI: NetworkAPI {
    var path: String {
        switch self {
        case .test:
            return "test"
        case .invalid:
            return "$#%"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .test:
            return .get
        case .invalid:
            return .delete
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .test:
            return ["keyTest": "valueTest"]
        case .invalid:
            return nil
        }
    }
    
    var baseURL: String {
        switch self {
        case .test:
            return "https://test.com/"
        case .invalid:
            return "%%%"
        }
    }
}
