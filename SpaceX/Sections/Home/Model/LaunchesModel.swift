//
//  LaunchesModel.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import Foundation

struct LaunchesModel: Codable {
    let missionName: String
    let launchDate: Int
    let rocket: Rocket
    let launchYear: String?
    let launchSuccess: Bool?
    let links: Links

    enum CodingKeys: String, CodingKey {
        case missionName = "mission_name"
        case launchDate = "launch_date_unix"
        case rocket
        case launchSuccess = "launch_success"
        case links
        case launchYear = "launch_year"
    }
}

struct Links: Codable {
    let articleLink: String?
    let videoLink: String?
    let wikipediaLink: String?
    let smallImage: String?
    let largeImage: String?
    
    var smallImageUrl: URL? {
        guard let urlString = smallImage, let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    var largeImageUrl: URL? {
        guard let urlString = largeImage, let url = URL(string: urlString) else {
            return nil
        }
        return url
    }

    enum CodingKeys: String, CodingKey {
        case articleLink = "article_link"
        case smallImage = "mission_patch_small"
        case largeImage = "mission_patch"
        case wikipediaLink = "wikipedia"
        case videoLink = "video_link"
    }
}

struct Rocket: Codable {
    let rocketName, rocketType: String

    enum CodingKeys: String, CodingKey {
        case rocketName = "rocket_name"
        case rocketType = "rocket_type"
    }
}
