//
//  WeatherInfo.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/10.
//

import Foundation

class WeatherInfo: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    var current: Current? = nil
    var hourly: [Hourly]? = nil
    var daily: [Daily]? = nil
}

class Current: DefaultWeatherInfo {
    var temp: Double = 0
}

class Hourly: DefaultWeatherInfo {
    var temp: Double = 0
}

class Daily: DefaultWeatherInfo {
}

class DefaultWeatherInfo: Codable {
    let dt: Int
    let weather: [Weather]
    
    func printDataTime() {
        let now = Date(timeIntervalSince1970: Double(dt))
        let formatter: DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko_KR")
            df.timeZone = TimeZone(abbreviation: "KST")
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return df
        }()
        print("now: \(formatter.string(from: now))")
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}