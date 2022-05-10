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
    
    func printCurrentTime() {
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
