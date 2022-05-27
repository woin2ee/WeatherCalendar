//
//  TodoItem.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/27.
//

import Foundation

struct TodoItem {
    let date: String
    let content: String
    
    private init (date: String, content: String) {
        self.date = date
        self.content = content
    }
    
    static func create(date: String, content: String) -> TodoItem {
        return TodoItem(date: date, content: content)
    }
}
