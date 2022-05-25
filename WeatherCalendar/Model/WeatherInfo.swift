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
    var current: Current
    var hourly: [Hourly]
    var daily: [Daily]
    
    static func of(_ location: (lat: Double, lon: Double)) async throws -> WeatherInfo? {
        // URL 형식 참조: https://openweathermap.org/api/one-call-api
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(location.lat)&lon=\(location.lon)&exclude=minutely,alerts&appid=\(Storage.API_KEY)") else { return nil }
        let (data, response) = try await URLSession.shared.data(from: url)
        let successRange = 200..<300
        guard successRange.contains((response as? HTTPURLResponse)?.statusCode ?? 0) else { return nil }
        return try JSONDecoder().decode(WeatherInfo.self, from: data)
    }
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
