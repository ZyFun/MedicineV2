//
//  MedicineInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.12.2021.
//

import Foundation

/// Протокол для работы с бизнес логикой модуля
protocol MedicineBusinessLogic {
    /// Метод еще не доделан
    func requestData(at indexPath: IndexPath)
    
    /// Сохранение или создание нового лекарства
    /// - Если лекарство nil, создаётся новое лекарство. Если нет, идет редактирование текущего
    /// лекарства.
    /// - Parameters:
    ///   - name: принимает название лекарства
    ///   - type: принимает тип лекарства
    ///   - amount: принимает количество лекарств
    ///   - countSteps: принимает количество шагов степпера
    ///   - expiryDate: принимает дату срока годности
    ///   - currentFirstAidKit: принимает текущую аптечку (используется для связи лекарства
    ///   с аптечкой)
    ///   - medicine: принимает текущее лекарство
    func createMedicine(
        name: String?,
        type: String?,
        amount: String?,
        countSteps: String?,
        expiryDate: String?,
        currentFirstAidKit: FirstAidKit?,
        medicine: inout Medicine?
    )
}

final class MedicineInteractor {
    /// Ссылка на презентер
    weak var presenter: MedicinePresentationLogic?
}

extension MedicineInteractor: MedicineBusinessLogic {
    func createMedicine(
        name: String?,
        type: String?,
        amount: String?,
        countSteps: String?,
        expiryDate: String?,
        currentFirstAidKit: FirstAidKit?,
        medicine: inout Medicine?
    ) {
            
        // Проверяем на отсутствие значения
        if name == nil {
            presenter?.showError()
            return
        }
        
        // Проверяем на попытку создания нового лекарства
        if medicine == nil {
            medicine = Medicine()
        }
        
        // Создание связи лекарства к аптечке.
        // Нужно понять, как делать фильтрацию предикатом, отображая лекарства
        // которые были привязаны к конкретной аптечке.
        if let currentFirstAidKit = currentFirstAidKit {
            medicine?.firstAidKit = currentFirstAidKit
        }
        
        // Если лекарство есть в базе, меняем его параметры.
        // Если это новое лекарство, сохраняем введенные значения.
        if let medicine = medicine {
            medicine.dateCreated = Date()
            medicine.title = name
            medicine.type = type
            medicine.amount = amount?.doubleValue ?? 0
            // Расширение возвращает 0, но с 0 будет краш приложения
            // при открытии такого лекарства. По этому, значение по умолчанию 1.
            medicine.stepCountForStepper = countSteps?.doubleValue ?? 1
            medicine.expiryDate = expiryDate?.toDate()
        }
        
        // Сохраняем все изменения в базе
        StorageManager.shared.saveContext()
    }
    
    func requestData(at indexPath: IndexPath) {
        // TODO: Доделать
    }
}
