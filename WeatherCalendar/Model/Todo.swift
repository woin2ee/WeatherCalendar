//
//  Todo.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/12.
//

import Foundation
import CoreData

class Todo {
    struct TodoItem {
        var date: String
        var content: String
    }
//    var list: Dictionary<String, [String]> // cache 역할 개발 예정 not null
    
    func createItem(date: String, content: String) -> TodoItem {
        return TodoItem(date: date, content: content)
    }
    
    func save(item: Todo.TodoItem) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TodoList", in: context)
        
        var fetchResult: [NSManagedObject]
        do {
            fetchResult = try context.fetch(getFetchRequestFiltered(by: item.date))
        } catch {
            fetchResult = []
            print(error.localizedDescription)
        }
        
        if fetchResult.isEmpty { // date키 값이 없을때 = Create
            if let entity = entity {
                let list = [item.content]
                let managedObj = NSManagedObject(entity: entity, insertInto: context)
                managedObj.setValue(item.date, forKey: "date")
                managedObj.setValue(list, forKey: "list")
            }
        } else { // date키 값이 있을때 = Update
            var newList = fetchResult.first?.value(forKey: "list") as! [String]
            newList.append(item.content)
            
            let managedObj = fetchResult.first
            managedObj?.setValue(newList, forKey: "list")
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchList(by date: String) -> [String] {
        let context = persistentContainer.viewContext
        let fetchResult = try? context.fetch(getFetchRequestFiltered(by: date))
        return fetchResult?.first?.value(forKey: "list") as? [String] ?? []
    }
    
    private func getFetchRequestFiltered(by date: String) -> NSFetchRequest<NSManagedObject> {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TodoList")
        fetchRequest.predicate = NSPredicate(format: "date = %@", date)
        return fetchRequest
    }
    
    func showAllTodoList() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TodoList")
        do {
            let fetchResult = try context.fetch(fetchRequest)
            fetchResult.forEach {
                print("\($0.value(forKey: "date") as? String ?? "nil") : \($0.value(forKey: "list") as? [String] ?? ["nil"])")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Todo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version. Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
