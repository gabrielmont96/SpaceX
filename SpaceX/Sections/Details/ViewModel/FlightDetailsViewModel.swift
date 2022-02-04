//
//  DetailsViewModel.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 17/01/22.
//

import Foundation

protocol FlightDetailsViewModelProtocol {
    var imageUrl: String? { get }
    func getUrl(for website: FlightDetailsWebsite) -> URL
}

enum FlightDetailsWebsite {
    case wikipedia
    case article
    case video
}

class FlightDetailsViewModel: FlightDetailsViewModelProtocol {
    private let links: Links
    
    var imageUrl: String? {
        return links.largeImage
    }
    
    init(links: Links) {
        self.links = links
    }
    
    func getUrl(for website: FlightDetailsWebsite) -> URL {
        let websiteUrl: String?
        switch website {
        case .article:
            websiteUrl = links.articleLink
        case .wikipedia:
            websiteUrl = links.wikipediaLink
        case .video:
            websiteUrl = links.videoLink
        }
        
        guard let urlString = websiteUrl,
              let url = URL(string: urlString) else {
            return URL(fileURLWithPath: "invalid url")
        }
        return url
    }
}
