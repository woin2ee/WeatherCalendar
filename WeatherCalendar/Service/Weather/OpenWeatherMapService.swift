//
//  OpenWeatherMapService.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/25.
//

import Foundation

// https://openweathermap.org
struct OpenWeatherMapService: WeatherServiceProtocol {
    
    let location: Location.Coord
    
    func fetchWeatherData(completion: @escaping (Result<WeatherData, APIRequestError>) -> Void) {
        // URL 형식 참조: https://openweathermap.org/api/one-call-api
        guard let url = URL(
            string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(location.lat)&lon=\(location.lon)&exclude=minutely,alerts&appid=\(Storage.API_KEY)"
        ) else {
            return completion(.failure(.invalidURL))
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                return completion(.failure(.anyError))
            }
            
            guard let response = urlResponse as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                return completion(.failure(.failureStatusCode))
            }
            
            guard let data = data else {
                return completion(.failure(.missingData))
            }
            
            guard let decodedData = try? JSONDecoder().decode(WeatherData.self, from: data) else {
                return completion(.failure(.decodeError))
            }
            
            completion(.success(decodedData))
        }
        
        task.resume()
    }
    
}
