//
//  NetworkAPI.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case update = "PUT"
    case delete = "DELETE"
}

protocol NetworkAPI {
    
    /// The Domain
    var baseURL: String { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}

extension NetworkAPI {
    var baseURL: String {
        return "https://api.spacexdata.com/"
    }
}
