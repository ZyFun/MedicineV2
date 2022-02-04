//
//  MedicineInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.12.2021.
//

import Foundation

protocol MedicineBusinessLogic {
    /// Метод для сохранения всех изменений в БД
    func saveMedicine()
    
    func requestData(at indexPath: IndexPath)
}

final class MedicineInteractor {
    weak var presenter: MedicinePresentationLogic?
}

extension MedicineInteractor: MedicineBusinessLogic {
    func saveMedicine() {
        StorageManager.shared.saveContext()
    }
    
    func requestData(at indexPath: IndexPath) {
        // TODO: Доделать
    }
}
