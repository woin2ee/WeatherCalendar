//
//  StubTodoStorage.swift
//  WeatherCalendarTests
//
//  Created by Jaewon on 2022/06/07.
//

import Foundation
import CoreData
@testable import WeatherCalendar

class StubTodoStorage: CoreDataSupport, TodoRepository {
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
    
    func save(item: TodoItem) {
        guard let entity = entity else { return }
        
        let newObj = TodoItem(entity: entity, insertInto: context)
        newObj.id = item.id
        newObj.date = item.date
        newObj.content = item.content
        
        //        let newObject = NSManagedObject(entity: entity, insertInto: context)
        //        newObject.setValue(item.id, forKey: "id")
        //        newObject.setValue(item.date, forKey: "date")
        //        newObject.setValue(item.content, forKey: "content")
        
        saveContext()
    }
    
    func update(item: TodoItem) {
        return
    }
    
    func fetch(by id: UUID) -> TodoItem {
        return TodoItem()
    }
    
    func fetchList(by date: Date) -> [TodoItem] {
        return [TodoItem]()
    }
    
    func fetchAll() -> [TodoItem] {
        let request = TodoItem.fetchRequest()
        let results = getResults(by: request)
        return results
    }
    
    func delete(item: TodoItem) {
        return
    }
    
    func deleteAll() {
        let request = TodoItem.fetchRequest()
        let results = getResults(by: request)
        results.forEach {
            context.delete($0)
        }
        saveContext()
    }
    
    func getResults<T>(by request: NSFetchRequest<T>) -> [T] where T: NSFetchRequestResult {
        do {
            return try context.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getFetchRequestFiltered(by date: String) -> NSFetchRequest<NSManagedObject> {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "date = %@", date)
        return fetchRequest
    }
    
//    func fetchAllTodoListAndExecuteEach(procedure: (NSManagedObject) -> Void) {
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
//        let fetchResult = getResult(request: fetchRequest)
//        fetchResult.forEach {
//            procedure($0)
//        }
//    }
}
