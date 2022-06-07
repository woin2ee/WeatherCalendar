//
//  TodoRepository.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/06/07.
//

import Foundation

protocol TodoRepository {
    func save(item: TodoItem)
    func update(item: TodoItem)
    func fetch(by id: UUID) -> TodoItem
    func fetchList(by date: Date) -> [TodoItem]
    func fetchAll() -> [TodoItem]
    func delete(item: TodoItem)
    func deleteAll()
}
