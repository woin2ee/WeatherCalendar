//
//  TodoService.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/12.
//

import Foundation

struct TodoService {
    private let todoRepository = TodoStorage()
     
    func save(item: TodoItem) {
        todoRepository.save(item: item)
    }
    
    func fetchList(by date: Date) -> [TodoItem] {
        return todoRepository.fetchList(by: date)
    }
    
    func fetchAll() -> [TodoItem] {
        return todoRepository.fetchAll()
    }
    
    func delete(item: TodoItem) {
        todoRepository.delete(item: item)
    }
}
