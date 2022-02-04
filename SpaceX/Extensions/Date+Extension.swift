//
//  Date+Extension.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import Foundation

public extension Date {
    enum DateFormatStyle: String {
        case fullDate = "MM-yyyy 'at' HH:mm"
    }
    
    func toStringWithFormat(_ format: DateFormatStyle) -> String {
        return toStringWithFormat(format.rawValue)
    }

    func toStringWithFormat(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
