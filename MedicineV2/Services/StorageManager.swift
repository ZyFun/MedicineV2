//
//  StorageManager.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//

import CoreData

protocol StorageManagerProtocol {
    func saveData()
    func fetchData()
    func editData()
    func deleteData()
}

/// Все действия с базой данных происходят через экземпляр этого класса (Singleton)
final class StorageManager {
    
    /// Глобальная точка доступа к созданному экземпляру класса (pattern Singleton)
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    /// Это точка входа в базу данных. Все действия с базой происходят через это свойство
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Medicine")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    ///  Область для работы с данными базы данных, в оперативной памяти
    private let viewContext: NSManagedObjectContext
    
    // Предотвращаем возможность создания других экземпляров класса, кроме той, что создана в классе (pattern Singleton)
    private init() {
        // Обращаемся к контейнеру, чтобы получить данные из базы
        viewContext = persistentContainer.viewContext
    }

}

// MARK: - Core Data Saving support
extension StorageManager {
    
    /// Метод, который производит сохранение данных, если были какие либо изменения в данных
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
