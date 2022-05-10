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
    var current: Current? = nil
    var hourly: [Hourly]? = nil
    var daily: [Daily]? = nil
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
    
    func printDataTime() {
        let now = Date(timeIntervalSince1970: Double(dt))
        let formatter: KRDateFormatter = {
            let df = KRDateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return df
        }()
        print("now: \(formatter.string(from: now))")
    }
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
