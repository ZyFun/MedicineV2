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
}
