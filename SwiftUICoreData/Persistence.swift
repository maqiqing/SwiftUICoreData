//
//  Persistence.swift
//  SwiftUICoreData
//
//  Created by maqiqing on 2022/6/22.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    
//    static var preview: PersistenceController = {
//
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//
//        for index in 0..<10 {
//            let newItem = ToDoItem(context: viewContext)
//            newItem.id = UUID()
//            newItem.name = "待办事项\(index)"
//            newItem.priority = .normal
//            newItem.isCompleted = false
//
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()


    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftUICoreData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
