//
//  HomeModel.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import Foundation

struct InfoModel: Codable {
    let name, founder: String
    let year, employees, launchSites: Int
    let valuation: Double

    enum CodingKeys: String, CodingKey {
        case name, founder, employees
        case launchSites = "launch_sites"
        case year = "founded"
        case valuation
    }
}
