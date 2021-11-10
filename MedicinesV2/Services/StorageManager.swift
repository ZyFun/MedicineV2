//
//  StorageManager.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//
// TODO: Посмотреть второй урок с разбором ДЗ, так как там будет объяснение работы замыкания. Я не понмю как точно это всё работает, переписал из своего прошлого кода

import CoreData

/// Протокол для работы с базой данных
protocol StorageManagerProtocol {
    func saveData(_ firstAidKitName: String, completion: (FirstAidKit) -> Void)
    func fetchData(completion: (Result<[FirstAidKit], Error>) -> Void)
    func editData(_ firstAidKit: FirstAidKit, newName: String)
    func deleteData(_ firstAidKit: FirstAidKit)
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
    
    /// Метод, который производит сохранение данных, если были какие либо изменения в данных. Хороший способ применения, сохранение при закрытии приложения.
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

// MARK: - Методы для действий с базой данных
extension StorageManager: StorageManagerProtocol {
    /// Метод для сохранения данных в базу данных
    /// - Parameters:
    ///   - firstAidKitName: принимает название аптечки, которое будет сохранено в базу
    ///   - completion: возвращает вновь созданный объект, для его присвоения массиву аптечек и отображения в таблице
    func saveData(_ firstAidKitName: String, completion: (FirstAidKit) -> Void) {
        
        // Этот код предпочтительнее использовать, если работа идет с множеством различных контекстов и типов данных, чтобы подтянуть всю необходимую информацию.
        // Но как применять всё это на практике, я пока не знаю.
        /*
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "FirstAidKit", in: viewContext) else { return }
        guard let firstAidKit = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? FirstAidKit else { return }
        */
        
        let firstAidKit = FirstAidKit(context: viewContext)
        firstAidKit.title = firstAidKitName
        completion(firstAidKit)
        saveContext()
    }
    
    /// Метод загрузки данных из базы в память устройства
    /// - Parameter completion: загружает данные из базы данных и сохраняет их в массив, возвращая экземпляр перечислений с обработкой ошибок, где в ответе приходит массив аптечек из базы
    func fetchData(completion: (Result<[FirstAidKit], Error>) -> Void) {
        let fetchRequest = FirstAidKit.fetchRequest()
        
        do {
            let firstAidKits = try viewContext.fetch(fetchRequest)
            completion(.success(firstAidKits))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    /// Метод для изменения значения аптечки
    /// - Parameters:
    ///   - firstAidKit: принимает аптечку со старым названием
    ///   - newName: принимает новое название аптечки и заменяет старое
    func editData(_ firstAidKit: FirstAidKit, newName: String) {
        firstAidKit.title = newName
        saveContext()
    }
    
    /// Метод для удаления аптечки из базы
    /// - Parameter firstAidKit: принимает аптечку, которая будет удалена из базы
    func deleteData(_ firstAidKit: FirstAidKit) {
        viewContext.delete(firstAidKit)
        saveContext()
    }
    
}
