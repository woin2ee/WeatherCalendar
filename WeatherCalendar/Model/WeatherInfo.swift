//
//  WeatherInfo.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/10.
//

import Foundation

enum APIOptions {
    case current, hourly, daily, all
}

struct WeatherInfo: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    var current: Current? = nil
    var hourly: [Hourly]? = nil
    var daily: [Daily]? = nil
    
    /// - Parameter options: [current: 현재 시각의 날씨 데이터, hourly: 현재 시각 기준 48시간의 예측 데이터, daily: 오늘 기준 7일 동안의 예측 데이터, all: 모두]
    static func of(_ location: (lat: Double, lon: Double), _ option: APIOptions = .all) async throws -> WeatherInfo? {
        let excludeString: String
        switch option {
        case .current:
            excludeString = "minutely,alerts,hourly,daily"
        case .hourly:
            excludeString = "minutely,alerts,current,daily"
        case .daily:
            excludeString = "minutely,alerts,hourly,current"
        case .all:
            excludeString = "minutely,alerts"
        }
        // URL 형식 참조: https://openweathermap.org/api/one-call-api
        // Asia/Seoul - (lat: 37.5683 , lon: 126.9778)
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(location.lat)&lon=\(location.lon)&exclude=\(excludeString)&appid=\(Storage.API_KEY)")
        else {
            debugPrint(#function)
            return nil
        }
        let (data, response) = try await URLSession.shared.data(from: url) // url 요청이 실패하면 throw
        let successRange = 200..<300
        guard successRange.contains((response as? HTTPURLResponse)?.statusCode ?? 0) else {
            debugPrint(#function)
            return nil
        }
        return try JSONDecoder().decode(WeatherInfo.self, from: data) // decode 실패하면 throw
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
    
    // Debug용 확인 함수
    func printDataTime() {
        let now = Date(timeIntervalSince1970: Double(dt))
        let formatter: DateFormatter = {
            let df = CustomDateFormatter.kr()
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
