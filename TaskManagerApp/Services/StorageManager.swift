//
//  StorageManager.swift
//  TaskManagerApp
//
//  Created by Konstantin Korchak on 19.04.2022.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskManagerApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func fetchTasks() -> [TaskStorageModel] {
        let viewContext = persistentContainer.viewContext
        var tasks: [TaskStorageModel] = []
        
        let fetchRequest = TaskStorageModel.fetchRequest()
        do {
            tasks = try viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return tasks
    }
    
    func saveTaskContext () {
        let viewContext = persistentContainer.viewContext
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveNewTaskContext (_ text: String) {
        let viewContext = persistentContainer.viewContext
        let task = TaskStorageModel(context: viewContext)
        task.taskTitle = text
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
