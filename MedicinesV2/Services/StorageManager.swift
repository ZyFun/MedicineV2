//
//  StorageManager.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//
// TODO: Посмотреть второй урок с разбором ДЗ, так как там будет объяснение работы замыкания. Я не понмю как точно это всё работает, переписал из своего прошлого кода

import CoreData

protocol StorageManagerProtocol {
    func saveData(_ firstAidKitName: String, completion: (FirstAidKit) -> Void)
    func fetchData(completion: (Result<[FirstAidKit], Error>) -> Void)
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
        let container = NSPersistentContainer(name: "Medicines")
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

// MARK: - Методы для всех действий с базой данных
extension StorageManager: StorageManagerProtocol {
    func saveData(_ firstAidKitName: String, completion: (FirstAidKit) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "FirstAidKit", in: viewContext) else { return }
        guard let firstAidKit = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? FirstAidKit else { return }
        firstAidKit.title = firstAidKitName
        completion(firstAidKit)
        saveContext()
    }
    
    func fetchData(completion: (Result<[FirstAidKit], Error>) -> Void) {
        let fetchRequest = FirstAidKit.fetchRequest()
        
        do {
            let firstAidKits = try viewContext.fetch(fetchRequest)
            completion(.success(firstAidKits))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func editData() {
        
    }
    
    func deleteData() {
        
    }
    
}

// TODO: Добавить дополнение с меткой, до каких версий этот код актуально использовать, чтобы удалить этот код, когда поддержка этой версии будет прекращена. СЮда поместить код, который очищает лишние ячейки в таблице для версий iOS ниже 15.
