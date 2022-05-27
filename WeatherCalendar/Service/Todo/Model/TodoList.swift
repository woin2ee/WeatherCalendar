//
//  TodoList.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/28.
//

import Foundation

struct TodoList {
    let date: String
    let list: [String]
    
    var count: Int {
        return list.count
    }
    
    subscript (index: Int) -> String {
        return list[index]
    }
}
