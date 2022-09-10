//
//  StoreManager.swift
//  TaskList
//
//  Created by Алексей Гайдуков on 08.09.2022.
//

import CoreData
import Foundation

class StoreManager {
    static let shared = StoreManager()
    
   
    // MARK: - Core Data stack

    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    private init() {
        viewContext =  persistentContainer.viewContext
    }

    
    // MARK: - CRUD
    func create(_ taskName: String, complition: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = taskName
        complition(task)
        saveContext()
    }
    
    func fetchData(complition: (Result<[Task], Error>) -> Void ) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let task = try viewContext.fetch(fetchRequest)
            complition(.success(task))
        } catch let error {
            complition(.failure(error))
        }
    }
    
    func update(_ task: Task, newName: String) {
        task.title = newName
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
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

