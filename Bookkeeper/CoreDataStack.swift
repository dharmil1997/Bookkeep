//
//  CoreDataStack.swift
//  Bookkeeper
//
//

import Foundation
import CoreData

enum CoreDataOperation {
    case success
    case failed
}

class CoreDataStack {
    
    static let shared = CoreDataStack(modelName: "Bookkeeper")
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    //MARK: - TASK 1
    // 1 - Fill out the missing part in the section below to initialize the Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    
    //MARK: - TASK 2
    //2 - Fill out the Core Data saving function it should return a CoreDataOperation.failed if saving has failed.
    //otherwise it should return .success
    func saveContext() -> CoreDataOperation {
        do {
            try managedContext.save()
            return .success
        } catch {
            return .failed
        }
    }
    
    // MARK: - TASK 3
    // 3 - Create a generic Core Data fetch request by filling out the function below
    func fetchEntities<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T]? {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entity))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch {
            print("Failed to fetch entities: \(error)")
            return nil
        }
    }
}

