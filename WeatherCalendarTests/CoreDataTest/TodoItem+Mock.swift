//
//  TodoItem+Mock.swift
//  WeatherCalendarTests
//
//  Created by Jaewon on 2022/06/07.
//

import Foundation
@testable import WeatherCalendar

extension TodoItem {
    static func mock() -> TodoItem {
        let item = TodoItem()
        item.id = UUID(uuidString: "test")
        item.date = Date()
        item.content = "content"
        return item
    }
}
