//
//  Medicine+CoreDataClass.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.11.2021.
//
//

import Foundation
import CoreData

@objc(Medicine)
public class Medicine: NSManagedObject {
    // TODO: Почитать подробнее про вспомогательные инициализаторы
    // До конца еще не понял. Но я так понимаю, подобным способом я избегаю постоянного создания описания модели и могу достаточно просто инициализировать объект для работы с ним.
    convenience init() {
        self.init(entity: StorageManager.shared.forEntityName("Medicine"),
                  insertInto: StorageManager.shared.viewContext)
    }
    
//    // TODO: разобраться с предикатом. Настроил работу и без него, но мне интересно
//    class func getRowOfOrder(_ medicine: Medicine) -> NSFetchedResultsController<NSFetchRequestResult> {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RowOfOrder")
//
//        let sortDescriptor = NSSortDescriptor(key: "medicine.title", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        let predicate = NSPredicate(format: "%K == %@", "firstAidKit", medicine)
//        fetchRequest.predicate = predicate
//
//        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: StorageManager.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
//
//        return fetchedResultsController
//    }
}
