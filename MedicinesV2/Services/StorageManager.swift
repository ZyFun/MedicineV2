//
//  StorageManager.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//
// TODO: Посмотреть второй урок с разбором ДЗ по кордате, так как там будет объяснение работы замыкания. Я не понмю как точно это всё работает, переписал из своего прошлого кода

import CoreData

/// Протокол для работы с базой данных
protocol StorageManagerProtocol {
//    func saveData(_ firstAidKitName: String, completion: (FirstAidKit) -> Void)
//    func fetchData(completion: (Result<[FirstAidKit], Error>) -> Void)
//    func editData(_ firstAidKit: FirstAidKit, newName: String)
    func deleteObject(_ entity: NSManagedObject) // Так можно передать любую сущность базы данных
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
    let viewContext: NSManagedObjectContext
    
    // Предотвращаем возможность создания других экземпляров класса, кроме той, что создана в классе (pattern Singleton)
    private init() {
        // Обращаемся к контейнеру, чтобы получить данные из базы
        viewContext = persistentContainer.viewContext
    }
}

// MARK: - Core Data stack methods
extension StorageManager {
    /// Метод создаёт описание сущности. Используется в расширении для сущности, чтобы инициализировать описание, при инициализации самой сущности.
    /// - Parameter entityName: принимает название сущности, которое используется в базе данных
    /// - Returns: Entity Description
    func forEntityName(_ entityName: String) -> NSEntityDescription {
        // Извлекаю принудительно, так как сущность должна быть обязательной. Если её нет, то и в прод выпускать такое приложение нельзя. Если я ошибусь в названии на этапе разработки, приложение должно упасть.
        return NSEntityDescription.entity(forEntityName: entityName, in: viewContext)!
    }
    
    /// метод создаёт Fetched Results Controller для сущности БД
    /// - Parameters:
    ///   - entityName: принимает название сущности, которое используется в базе данных
    ///   - keyForSort: принимает ключ, по которому будет производится сортировка. Например по имени или по количеству
    /// - Returns: Fetched Results Controller
    func fetchedResultsController(entityName: String, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        // TODO: Доработать сортировку в будущем, чтобы пользователь мог сам выбирать направление сортировки и выбирал, по какому параметру производить сортировку.
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // TODO: Разобраться с параметрами кеширования и научится с ними работать.
        let fetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
}

// MARK: - CRUD
extension StorageManager: StorageManagerProtocol {
    
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
    
    /// Метод для удаления данных из базы
    /// - Parameter entity: принимает entity, которая будет удалена из базы
    func deleteObject(_ entity: NSManagedObject) {
        viewContext.delete(entity)
        saveContext()
    }
    
    /*
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
     */
    
    // Это тестовый метод для создания аптечки и лекарств при первом старте приложения. В данной реализации уже особо не работает, требуется переписать
//    func startingFirstAidKit() -> Medicine {
//        let firstAidKit = FirstAidKit(context: viewContext)
//        firstAidKit.title = "Ваша аптечка"
//        
//        let medicine = Medicine(context: viewContext)
//        medicine.title = "Ваше лекарство"
//        medicine.box = firstAidKit
//        
//        saveContext()
//        
//        return medicine
//    }
}
