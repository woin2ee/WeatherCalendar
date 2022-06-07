//
//  CoreDataSupport.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/28.
//

import Foundation
import CoreData

protocol CoreDataSupport {
    var persistentContainer: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
    var entityName: String { get }
    var entity: NSEntityDescription? { get }
    
    func saveContext()
}

extension CoreDataSupport {
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    var entity: NSEntityDescription? {
        NSEntityDescription.entity(forEntityName: entityName, in: context)
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
