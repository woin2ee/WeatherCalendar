//
//  Todo.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/12.
//

import Foundation

struct Todo {
    static var items: Dictionary<String, [String]> = ["2022. 5. 11.": ["first", "second"]]
    
    static func getItem(as date: String) -> [String] {
        return items[date] ?? ["목록을 불러올 수 없습니다."]
    }
}
