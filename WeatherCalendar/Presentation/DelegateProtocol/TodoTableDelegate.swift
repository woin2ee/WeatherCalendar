//
//  TodoTableDelegate.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/26.
//

import Foundation

protocol TodoTableDelegate: AnyObject {
    func loadTodoList(selected date: Date)
    func scrollToBottom()
}
