//
//  HourlyWeatherDateFormatter.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/25.
//

import Foundation

class HourlyWeatherDateFormatter: DateFormatter {
    override init() {
        super.init()
        super.locale = Locale(identifier: "ko_KR")
        super.timeZone = TimeZone(abbreviation: "KST")
        super.dateFormat = "HH:mm"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
