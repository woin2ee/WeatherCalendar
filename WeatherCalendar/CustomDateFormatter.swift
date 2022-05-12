//
//  CustomDateFormatter.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/12.
//

import Foundation

class CustomDateFormatter: DateFormatter {
    static func kr() -> DateFormatter {
        let formatter: DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko_KR")
            df.timeZone = TimeZone(abbreviation: "KST")
            return df
        }()
        return formatter
    }
    
    static func forTodo() -> DateFormatter {
        let formatter: DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko_KR")
            df.timeZone = TimeZone(abbreviation: "KST")
            df.dateStyle = .medium
            df.timeStyle = .none
            return df
        }()
        return formatter
    }
}

// CustomDateFormatter.kr()
// CustomDateFormatter.forTodo().string()
