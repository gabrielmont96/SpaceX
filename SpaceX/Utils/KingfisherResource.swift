//
//  Resource.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 25/01/22.
//

import Foundation
import Kingfisher

struct KingfisherResource: Resource {
    var cacheKey: String
    var downloadURL: URL
}
