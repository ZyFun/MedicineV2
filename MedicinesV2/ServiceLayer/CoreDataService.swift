//
//  CoreDataService.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//

import CoreData

/// Протокол для работы с базой данных
protocol ICoreDataService {
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    func fetchResultController(
        entityName: String,
        keyForSort: String,
        sortAscending: Bool,
        currentFirstAidKit: DBFirstAidKit?
    ) -> NSFetchedResultsController<NSFetchRequestResult>
    func fetchRequest(_ entityName: String) -> [NSFetchRequestResult]
    func fetchFirstAidKits(from context: NSManagedObjectContext, completion: (Result<[DBFirstAidKit], Error>) -> Void)
    func createFirstAidKit(_ firstAidKitName: String, context: NSManagedObjectContext)
    func createMedicine(_ medicine: MedicineModel, currentFirstAidKit: DBFirstAidKit?, context: NSManagedObjectContext)
    func updateFirstAidKit(_ firstAidKit: DBFirstAidKit, newName: String, context: NSManagedObjectContext)
    func updateMedicine(_ oldObject: DBMedicine, newData: MedicineModel, context: NSManagedObjectContext)
    func delete(_ currentObject: NSManagedObject, context: NSManagedObjectContext)
}
 
/// Все действия с базой данных происходят через экземпляр этого класса (Singleton)
final class CoreDataService {
    
    /// Глобальная точка доступа к созданному экземпляру класса (pattern Singleton)
    static let shared = CoreDataService()
    
    // MARK: - Core Data stack
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Medicines")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                Logger.error("\(error)")
            } else {
                Logger.info("\(storeDescription)")
            }
        }
        return container
    }()
    
    private lazy var readContext: NSManagedObjectContext = {
        let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private lazy var writeContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }()
    
    private init() {}
}

// MARK: - CRUD

extension CoreDataService: ICoreDataService {
    
    func fetchResultController(
        entityName: String,
        keyForSort: String,
        sortAscending: Bool,
        currentFirstAidKit: DBFirstAidKit? = nil
    ) -> NSFetchedResultsController<NSFetchRequestResult> {
        // FIXME: Вынести создание fetchRequest в отдельный класс типа фабрики для возможности создавать в fetchResultController различные типы запросов.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let descriptorDateLastActivity = NSSortDescriptor(key: keyForSort, ascending: sortAscending)
        
        fetchRequest.sortDescriptors = [descriptorDateLastActivity]
        
        if let currentFirstAidKit = currentFirstAidKit {
            fetchRequest.predicate = NSPredicate(format: "%K == %@", "firstAidKit", currentFirstAidKit)
            fetchRequest.fetchBatchSize = 15
        }
        
        let fetchResultController = NSFetchedResultsController<NSFetchRequestResult>(
            fetchRequest: fetchRequest,
            managedObjectContext: readContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        do {
            try fetchResultController.performFetch()
        } catch {
            Logger.error(error.localizedDescription)
        }
        
        return fetchResultController
    }
    
    /// Метод для сохранения аптечки в базу данных
    /// - Parameters:
    ///   - firstAidKitName: принимает название аптечки, которое будет сохранено в базу
    ///   - context: принимает контекст, в котором производится работа с базой
    func createFirstAidKit(_ firstAidKitName: String, context: NSManagedObjectContext) {
        let dbFirstAidKit = DBFirstAidKit(context: context)
        dbFirstAidKit.title = firstAidKitName

        Logger.info("Запуск сохранения \(dbFirstAidKit.title ?? "no name")")
    }
    
    func createMedicine(
        _ medicine: MedicineModel,
        currentFirstAidKit: DBFirstAidKit?,
        context: NSManagedObjectContext
    ) {
        let managedObject = NSEntityDescription.insertNewObject(
            forEntityName: String(describing: DBMedicine.self),
            into: context
        )
        
        guard let dbMedicine = managedObject as? DBMedicine else {
            Logger.error("Ошибка каста до DBMedicine")
            return
        }
        
        dbMedicine.dateCreated = medicine.dateCreated
        dbMedicine.title = medicine.title
        dbMedicine.type = medicine.type
        dbMedicine.amount = (medicine.amount) as? NSNumber
        dbMedicine.stepCountForStepper = (medicine.stepCountForStepper) as? NSNumber
        dbMedicine.expiryDate = medicine.expiryDate
        
        if let currentFirstAidKit = currentFirstAidKit {
            currentFirstAidKit.addToMedicines(dbMedicine)
            
            Logger.info("В базу добавлено новое лекарство.")
            Logger.info("Лекарств в базе: \(currentFirstAidKit.medicines?.count ?? 0)")
            Logger.info("для аптечки \(currentFirstAidKit.title ?? "no name")")
        }
    }
    
    func fetchFirstAidKits(from context: NSManagedObjectContext, completion: (Result<[DBFirstAidKit], Error>) -> Void) {
        let fetchRequest = DBFirstAidKit.fetchRequest()

        do {
            let firstAidKits = try context.fetch(fetchRequest)
            completion(.success(firstAidKits))
        } catch {
            completion(.failure(error))
        }
    }
    
    // TODO: (#Edit) Это лишний метод, сейчас используется для получения всех лекарств и добавлкния уведомлений.
    // Нужно отрефакторить этот функционал. Задача MED-113
    /// Метод получения данных из базы
    /// - Parameter entityName: имя сущности в базе данных
    /// - Returns: Возвращает массив с результатом запроса данных
    func fetchRequest(_ entityName: String) -> [NSFetchRequestResult] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        // Sort Descriptor
        // TODO: (#Update) Доработать сортировку в будущем, чтобы пользователь мог сам выбирать направление сортировки
        // выбирал, по какому параметру производить сортировку. По аналогии с методом fetchedResultsController.
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        var data = [NSFetchRequestResult]()
        do {
            data = try readContext.fetch(fetchRequest)
        } catch {
            Logger.error(error.localizedDescription)
        }

        return data
    }
    
    func updateFirstAidKit(_ firstAidKit: DBFirstAidKit, newName: String, context: NSManagedObjectContext) {
        let objectID = firstAidKit.objectID
        guard let currentObject = context.object(with: objectID) as? DBFirstAidKit else {
            Logger.error("Не удалось скастить объект до DBFirstAidKit")
            return
        }
        currentObject.title = newName
        
        Logger.info("Запуск изменения аптечки \(firstAidKit.title ?? "no name")")
    }
    
    func updateMedicine(_ medicine: DBMedicine, newData: MedicineModel, context: NSManagedObjectContext) {
        let objectID = medicine.objectID
        guard let currentObject = context.object(with: objectID) as? DBMedicine else {
            Logger.error("Не удалось скастить объект до DBMedicine")
            return
        }
        currentObject.title = newData.title
        currentObject.type = newData.type
        currentObject.amount = (newData.amount) as? NSNumber
        currentObject.stepCountForStepper = (newData.stepCountForStepper) as? NSNumber
        currentObject.expiryDate = newData.expiryDate
        
        Logger.info("Запуск изменения лекарства \(medicine.title ?? "no name")")
    }
    
    func delete(
        _ currentObject: NSManagedObject,
        context: NSManagedObjectContext
    ) {
        let objectID = currentObject.objectID
        let currentObject = context.object(with: objectID)
        context.delete(currentObject)

        Logger.info("Запуск удаления объекта из базы")
    }
    
    // MARK: - Save context
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = writeContext
        context.perform { [weak self] in
            block(context)
            Logger.info(
                "Проверка контекста на изменение"
            )
            if context.hasChanges {
                Logger.info(
                    "Данные изменены, попытка сохранения"
                )
                do {
                    try self?.performSave(in: context)
                } catch {
                    Logger.error(error.localizedDescription)
                }
            } else {
                Logger.info(
                    "Изменений нет"
                )
            }
            
            Logger.info(
                "Проверка контекста на изменение закончена"
            )
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        Logger.info(
            "Данные сохранены"
        )
    }
}
