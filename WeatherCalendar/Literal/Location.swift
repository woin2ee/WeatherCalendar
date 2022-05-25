//
//  Location.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/12.
//

import Foundation

enum Location {
    typealias Coord = (lat: Double, lon: Double)
    
    case seoul
    
    var coordinates: Coord {
        switch self {
        case .seoul:
            return (37.5683, 126.9778)
        }
    }
    
}
