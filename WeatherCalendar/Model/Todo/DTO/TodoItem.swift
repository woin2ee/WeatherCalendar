//
//  TodoItem.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/27.
//

import Foundation

struct TodoItem {
    var id: UUID?
    var date: Date?
    var content: String?
    
    static func create(id: UUID, date: Date, content: String) -> TodoItem {
        return TodoItem(
            id: id,
            date: date,
            content: content
        )
    }
}
