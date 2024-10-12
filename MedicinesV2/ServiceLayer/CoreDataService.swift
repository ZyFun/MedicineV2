//
//  CoreDataService.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//

import CoreData
import DTLogger

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
    /// Метод для получения данных из CoreData
    /// - Parameters:
    ///   - managedObject: принимает модель CoreData с которой предстоит работать.
    ///   - context: принимает контекст, в котором производится работа с данными.
    ///   - completion: возвращает Result или ошибку по завершению чтения данных из базы.
    func fetch<T: NSManagedObject>(
        _ managedObject: T.Type,
        from context: NSManagedObjectContext,
        completion: (Result<[T], Error>) -> Void
    )
    func create(_ firstAidKit: String, context: NSManagedObjectContext)
    func create(_ medicine: MedicineModel, in currentFirstAidKit: DBFirstAidKit?, context: NSManagedObjectContext)
    func update(_ currentFirstAidKit: DBFirstAidKit, newName: String, context: NSManagedObjectContext)
    func update(_ currentMedicine: DBMedicine, newData: MedicineModel, context: NSManagedObjectContext)
    func delete(_ currentObject: NSManagedObject, context: NSManagedObjectContext)
}
 
///  Класс для работы с CoreData
final class CoreDataService {
    static let shared: ICoreDataService = CoreDataService()
    
    private let logger: DTLogger = DTLogger.shared
    
    // MARK: - Core Data stack
    
    private lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Medicines")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                self.logger.log(.error, "\(error)")
            } else {
                self.logger.log(.info, "\(storeDescription)")
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
            logger.log(.error, error.localizedDescription)
        }
        
        return fetchResultController
    }
    
    /// Метод для сохранения аптечки в базу данных
    /// - Parameters:
    ///   - firstAidKitName: принимает название аптечки, которое будет сохранено в базу
    ///   - context: принимает контекст, в котором производится работа с базой
    func create(_ firstAidKit: String, context: NSManagedObjectContext) {
        let dbFirstAidKit = DBFirstAidKit(context: context)
        dbFirstAidKit.title = firstAidKit

        logger.log(.info, "Запуск сохранения \(dbFirstAidKit.title ?? "no name")")
    }
    
    func create(
        _ medicine: MedicineModel,
        in currentFirstAidKit: DBFirstAidKit?,
        context: NSManagedObjectContext
    ) {
        let managedObject = NSEntityDescription.insertNewObject(
            forEntityName: String(describing: DBMedicine.self),
            into: context
        )
        
        guard let dbMedicine = managedObject as? DBMedicine else {
            logger.log(.error, "Ошибка каста до DBMedicine")
            return
        }
        
        dbMedicine.dateCreated = medicine.dateCreated
        dbMedicine.title = medicine.title
        dbMedicine.type = medicine.type
        dbMedicine.purpose = medicine.purpose
        dbMedicine.amount = (medicine.amount) as? NSNumber
        dbMedicine.stepCountForStepper = (medicine.stepCountForStepper) as? NSNumber
		dbMedicine.activeIngredient = medicine.activeIngredient
		dbMedicine.manufacturer = medicine.manufacturer
        dbMedicine.expiryDate = medicine.expiryDate
		dbMedicine.userDescription = medicine.userDescription

        if let currentFirstAidKit = currentFirstAidKit {
            currentFirstAidKit.addToMedicines(dbMedicine)
            
            logger.log(
                .info,
                """
                В базу добавлено новое лекарство.
                Лекарств в базе: \(currentFirstAidKit.medicines?.count ?? 0)
                для аптечки \(currentFirstAidKit.title ?? "no name")
                """
            )
        }
    }
    
    func fetch<T: NSManagedObject>(
        _ managedObject: T.Type,
        from context: NSManagedObjectContext,
        completion: (Result<[T], Error>) -> Void
    ) {
        let fetchRequest = managedObject.fetchRequest()

        do {
            guard let dbObject = try context.fetch(fetchRequest) as? [T] else { return }
            completion(.success(dbObject))
        } catch {
            completion(.failure(error))
        }
    }
    
    // TODO: (#Edit) Это лишний метод, сейчас используется для получения всех лекарств и добавлкния уведомлений.
    // Нужно отрефакторить этот функционал.
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
            logger.log(.error, error.localizedDescription)
        }

        return data
    }
    
    func update(_ currentFirstAidKit: DBFirstAidKit, newName: String, context: NSManagedObjectContext) {
        let objectID = currentFirstAidKit.objectID
        guard let currentObject = context.object(with: objectID) as? DBFirstAidKit else {
            logger.log(.error, "Не удалось скастить объект до DBFirstAidKit")
            return
        }
        currentObject.title = newName
        
        logger.log(.info, "Запуск изменения аптечки \(currentFirstAidKit.title ?? "no name")")
    }
    
    func update(_ currentMedicine: DBMedicine, newData: MedicineModel, context: NSManagedObjectContext) {
        let objectID = currentMedicine.objectID
        guard let currentObject = context.object(with: objectID) as? DBMedicine else {
            logger.log(.error, "Не удалось скастить объект до DBMedicine")
            return
        }
        currentObject.title = newData.title
        currentObject.type = newData.type
        currentObject.purpose = newData.purpose
        currentObject.amount = (newData.amount) as? NSNumber
        currentObject.stepCountForStepper = (newData.stepCountForStepper) as? NSNumber
		currentObject.activeIngredient = newData.activeIngredient
		currentObject.manufacturer = newData.manufacturer
        currentObject.expiryDate = newData.expiryDate
		currentObject.userDescription = newData.userDescription

        logger.log(.info, "Запуск изменения лекарства \(currentMedicine.title ?? "no name")")
    }
    
    func delete(
        _ currentObject: NSManagedObject,
        context: NSManagedObjectContext
    ) {
        let objectID = currentObject.objectID
        let currentObject = context.object(with: objectID)
        context.delete(currentObject)

        logger.log(.info, "Запуск удаления объекта из базы")
    }
    
    // MARK: - Save context
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = writeContext
        context.perform { [weak self] in
            block(context)
            self?.logger.log(.info, "Проверка контекста на изменение")
            if context.hasChanges {
                self?.logger.log(.info, "Данные изменены, попытка сохранения")
                do {
                    try self?.performSave(in: context)
                } catch {
                    self?.logger.log(.error, error.localizedDescription)
                }
            } else {
                self?.logger.log(.info, "Изменений нет")
            }
            
            self?.logger.log(.info, "Проверка контекста на изменение закончена")
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        logger.log(.info, "Данные сохранены")
    }
}
