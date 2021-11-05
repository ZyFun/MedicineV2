//
//  StorageManager.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//

import CoreData

final class StorageManager {
    
    /// Глобальная точка доступа к созданному экземпляру класса (pattern Singleton)
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MedicineV2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Предотвращает возможность создания других экземпляров класса, кроме той, что создана в классе (pattern Singleton)
    private init() {}

}

// MARK: - Core Data Saving support
extension StorageManager {
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
