//
//  TodoService.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/12.
//

import Foundation
import CoreData

class TodoService: CoreDataServiceProtocol {
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Todo")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    let entityName: String = "TodoList"
    
    // MARK: - Core Data Persistent API
    
    func save(item: TodoItem) {
        let fetchResult = getFetchResult(request: getFetchRequestFiltered(by: item.date))
        
        if fetchResult.isEmpty {
            guard let entity = entity else { return }
            let list = [item.content]
            let managedObj = NSManagedObject(entity: entity, insertInto: context)
            managedObj.setValue(item.date, forKey: "date")
            managedObj.setValue(list, forKey: "list")
        } else {
            let list = fetchResult.first?.value(forKey: "list") as! [String]
            let newList = list + [item.content]
            let managedObj = fetchResult.first
            managedObj?.setValue(newList, forKey: "list")
        }
        
        saveContext()
    }
    
    func fetchAll() -> [String:[String]] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let fetchResult = getFetchResult(request: fetchRequest)
        var todo = [String:[String]]()
        fetchResult.forEach {
            todo[$0.value(forKey: "date") as? String ?? "nil"] = $0.value(forKey: "list") as? [String]
        }
        return todo
    }
    
    func fetchList(by date: String) -> [String] {
        let fetchResult = getFetchResult(request: getFetchRequestFiltered(by: date))
        return fetchResult.first?.value(forKey: "list") as? [String] ?? []
    }
    
    func fetchAllExistentDate() -> [String] {
        var dates = [String]()
        fetchAllTodoListAndExecuteEach {
            dates.append($0.value(forKey: "date") as? String ?? "")
        }
        return dates
    }
    
    func delete(date: String, content: String) {
        let fetchResult = getFetchResult(request: getFetchRequestFiltered(by: date))
        var list = fetchResult.first?.value(forKey: "list") as? [String]
        guard let index = list?.firstIndex(of: content) else { return }
        list?.remove(at: index)
        let managedObj = fetchResult.first
        managedObj?.setValue(list, forKey: "list")
        saveContext()
    }
    
    func showAllTodoList() {
        fetchAllTodoListAndExecuteEach {
            print("\($0.value(forKey: "date") as? String ?? "nil") : \($0.value(forKey: "list") as? [String] ?? ["nil"])")
        }
    }
    
    // MARK: - Private Method
    
    private func getFetchResult(request: NSFetchRequest<NSManagedObject>) -> [NSManagedObject] {
        do {
            return try context.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func getFetchRequestFiltered(by date: String) -> NSFetchRequest<NSManagedObject> {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "date = %@", date)
        return fetchRequest
    }
    
    private func fetchAllTodoListAndExecuteEach(procedure: (NSManagedObject) -> Void) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let fetchResult = getFetchResult(request: fetchRequest)
        fetchResult.forEach {
            procedure($0)
        }
    }
}
