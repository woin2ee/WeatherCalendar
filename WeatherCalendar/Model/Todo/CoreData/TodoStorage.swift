//
//  TodoStorage.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/06/07.
//

import Foundation
import CoreData

class TodoStorage: CoreDataSupport {
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Todo")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var entityName: String = "TodoItem"
}

// MARK: - Core Data Persistent API

extension TodoStorage: TodoRepository {
    func save(item: TodoItem) {
        guard let entity = entity else { return }
        
        let newObject = NSManagedObject(entity: entity, insertInto: context)
        newObject.setValue(item.id, forKey: "id")
        newObject.setValue(item.date, forKey: "date")
        newObject.setValue(item.content, forKey: "content")
        
        saveContext()
    }
    
    func update(item: TodoItem) {
        guard let id = item.id else { return }
        
        let request = getFetchRequestFiltered(by: id)
        let results = getResults(by: request)

        guard let result = results.first else { return }
        result.setValue(item.id, forKey: "id")
        result.setValue(item.date, forKey: "date")
        result.setValue(item.content, forKey: "content")
        
        saveContext()
    }
    
    func fetch(by id: UUID) -> TodoItem {
        let request = getFetchRequestFiltered(by: id)
        let results = getResults(by: request)
        return convert(list: results).first ?? TodoItem()
    }
    
    func fetchList(by date: Date) -> [TodoItem] {
        let request = getFetchRequestFiltered(by: date)
        let results = getResults(by: request)
        return convert(list: results)
    }
    
    func fetchAll() -> [TodoItem] {
        let request = getFetchRequest()
        let results = getResults(by: request)
        return convert(list: results)
    }
    
    func delete(item: TodoItem) {
        guard let id = item.id else { return }
        
        let request = getFetchRequestFiltered(by: id)
        let results = getResults(by: request)
        if results.count == 1 {
            context.delete(results.first!)
            saveContext()
        } else {
            debugPrint("\(id) - \(results.count)")
        }
    }
    
    func deleteAll() {
        let request = getFetchRequest()
        let results = getResults(by: request)
        results.forEach {
            context.delete($0)
        }
        saveContext()
    }
    
    // MARK: - Private
    
    private func getResults<T>(by request: NSFetchRequest<T>) -> [T] where T: NSFetchRequestResult {
        do {
            return try context.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func getFetchRequest() -> NSFetchRequest<NSManagedObject> {
        return NSFetchRequest<NSManagedObject>(entityName: entityName)
    }
    
    private func getFetchRequestFiltered(by date: Date) -> NSFetchRequest<NSManagedObject> {
        let request = getFetchRequest()
        request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
        return request
    }
    
    private func getFetchRequestFiltered(by id: UUID) -> NSFetchRequest<NSManagedObject> {
        let request = getFetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        return request
    }
    
    private func fetchAllTodoListAndExecuteEach<T>(procedure: (T) -> Void) where T: NSFetchRequestResult {
        let request = NSFetchRequest<T>(entityName: entityName)
        let results = getResults(by: request)
        results.forEach {
            procedure($0)
        }
    }
    
    private func convert(list: [NSManagedObject]) -> [TodoItem] {
        return list.map {
            TodoItem(
                id: $0.value(forKey: "id") as? UUID,
                date: $0.value(forKey: "date") as? Date,
                content: $0.value(forKey: "content") as? String
            )
        }
    }
}
