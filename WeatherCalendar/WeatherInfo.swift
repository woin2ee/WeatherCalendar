//
//  WeatherInfo.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/10.
//

import Foundation

struct WeatherInfo: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    let current: Current
}

struct Current: Codable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
