//
//  Todo.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/12.
//

import Foundation
import CoreData

struct Todo {
    struct List {
        let date: Date
        let list: [String]
        
        var count: Int {
            return list.count
        }
        
        subscript (index: Int) -> String {
            return list[index]
        }
    }
    
    struct Item {
        let date: String
        let content: String
        
        static func create(date: String, content: String) -> Item {
            return Item(date: date, content: content)
        }
    }
    
    // MARK: - Core Data stack
    
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Todo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    private static let context = persistentContainer.viewContext
    private static let entityName = "TodoList"
    private static let todoListEntity = NSEntityDescription.entity(forEntityName: entityName, in: context)
    
    // MARK: - Core Data Persistent API
    
    static func save(item: Todo.Item) {
        let fetchResult = getFetchResult(request: getFetchRequestFiltered(by: item.date))
        
        if fetchResult.isEmpty {
            guard let entity = todoListEntity else { return }
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
        
        self.saveContext()
    }
    
    static func fetchAll() -> [String:[String]] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let fetchResult = getFetchResult(request: fetchRequest)
        var todo = [String:[String]]()
        fetchResult.forEach {
            todo[$0.value(forKey: "date") as? String ?? "nil"] = $0.value(forKey: "list") as? [String]
        }
        return todo
    }
    
    static func fetchList(by date: String) -> [String] {
        let fetchResult = getFetchResult(request: getFetchRequestFiltered(by: date))
        return fetchResult.first?.value(forKey: "list") as? [String] ?? []
    }
    
    static func fetchAllExistentDate() -> [String] {
        var dates = [String]()
        fetchAllTodoListAndExecuteEach {
            dates.append($0.value(forKey: "date") as? String ?? "")
        }
        return dates
    }
    
    static func delete(date: Date, content: String) {
        let formattedDate = TodoDateFormatter().string(from: date)
        let fetchResult = getFetchResult(request: getFetchRequestFiltered(by: formattedDate))
        var list = fetchResult.first?.value(forKey: "list") as? [String]
        guard let index = list?.firstIndex(of: content) else { return }
        list?.remove(at: index)
        let managedObj = fetchResult.first
        managedObj?.setValue(list, forKey: "list")
        self.saveContext()
    }
    
    static func showAllTodoList() {
        fetchAllTodoListAndExecuteEach {
            print("\($0.value(forKey: "date") as? String ?? "nil") : \($0.value(forKey: "list") as? [String] ?? ["nil"])")
        }
    }
    
    // MARK: - Private Method
    
    private static func getFetchResult(request: NSFetchRequest<NSManagedObject>) -> [NSManagedObject] {
        do {
            return try context.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private static func getFetchRequestFiltered(by date: String) -> NSFetchRequest<NSManagedObject> {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "date = %@", date)
        return fetchRequest
    }
    
    private static func fetchAllTodoListAndExecuteEach(procedure: (NSManagedObject) -> Void) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let fetchResult = getFetchResult(request: fetchRequest)
        fetchResult.forEach {
            procedure($0)
        }
    }
    
    // MARK: - Core Data Saving support
    
    private static func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
