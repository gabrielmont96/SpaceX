//
//  NetworkError.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import Foundation

enum NetworkError: Error, Equatable {
    case api(statusCode: Int, message: String?)
    case invalidURL
    case invalidData
    case parseError(Error)
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
