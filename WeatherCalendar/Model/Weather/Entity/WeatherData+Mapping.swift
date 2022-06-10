//
//  WeatherData.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/10.
//

import Foundation
import UIKit

struct WeatherData: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Current: Codable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

struct Daily: Codable {
    let dt: Int
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

extension Hourly {
    func toDTO() -> HourlyWeatherDTO {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return .init(
            date: formatter.string(from: Date(timeIntervalSince1970: Double(dt))),
            kelvin: temp,
            iconImg: UIImage(named: weather.first?.icon ?? "")
        )
    }
}
