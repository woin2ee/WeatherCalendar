//
//  WeatherService.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/26.
//

import Foundation

protocol WeatherService {
    var successCode: Range<Int> { get }
    
    func fetchHourlyWeatherData(completion: @escaping (Result<[Hourly], APIRequestError>) -> Void)
}

extension WeatherService {
    var successCode: Range<Int> {
        (200..<300)
    }
}
