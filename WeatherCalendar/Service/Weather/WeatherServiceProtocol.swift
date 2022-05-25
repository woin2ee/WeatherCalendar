//
//  WeatherServiceProtocol.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/26.
//

import Foundation

protocol WeatherServiceProtocol {
    
    func fetchWeatherData(completion: @escaping (Result<WeatherData, APIRequestError>) -> Void)
    
}
