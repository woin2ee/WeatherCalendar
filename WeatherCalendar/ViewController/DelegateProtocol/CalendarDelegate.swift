//
//  CalendarDelegate.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/26.
//

import Foundation

protocol CalendarDelegate: AnyObject {
    func updateEventDot()
    func showTodoList(date: Date)
}
