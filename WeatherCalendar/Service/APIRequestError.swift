//
//  APIRequestError.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/26.
//

import Foundation

enum APIRequestError: Error {
    case invalidURL
    case failureStatusCode
    case missingData
    case decodeError
    case anyError
}
