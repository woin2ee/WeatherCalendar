//
//  KRDateFormatter.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/11.
//

import Foundation

class KRDateFormatter: DateFormatter {
    override init() {
        super.init()
        locale = Locale(identifier: "ko_KR")
        timeZone = TimeZone(abbreviation: "KST")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
