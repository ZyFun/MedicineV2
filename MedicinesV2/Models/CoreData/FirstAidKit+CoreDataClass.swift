//
//  FirstAidKit+CoreDataClass.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.11.2021.
//
//

import Foundation
import CoreData

@objc(FirstAidKit)
public class FirstAidKit: NSManagedObject {
    // TODO: Почитать подробнее про вспомогательные инициализаторы
    convenience init() {
        self.init(entity: StorageManager.shared.forEntityName("FirstAidKit"),
                  insertInto: StorageManager.shared.viewContext)
    }
}
