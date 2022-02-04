//
//  HomeNetwork.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import Foundation

enum HomeAPI {
    case info
    case launches
}

extension HomeAPI: NetworkAPI {
    var path: String {
        switch self {
        case .info:
            return "v3/info"
        case .launches:
            return "v3/launches"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        return [:]
    }
}
