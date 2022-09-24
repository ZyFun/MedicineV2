//
//  MedicineInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.12.2021.
//

import Foundation

/// Протокол для работы с бизнес логикой модуля
protocol MedicineBusinessLogic {
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
        currentFirstAidKit: DBFirstAidKit?,
        dbMedicine: DBMedicine?
    )
}

final class MedicineInteractor {
    /// Ссылка на презентер
    weak var presenter: MedicinePresentationLogic?
    var coreDataService: ICoreDataService?
    var notificationService: INotificationService?
}

extension MedicineInteractor: MedicineBusinessLogic {
    func createMedicine(
        name: String?,
        type: String?,
        amount: String?,
        countSteps: String?,
        expiryDate: String?,
        currentFirstAidKit: DBFirstAidKit?,
        dbMedicine: DBMedicine?
    ) {
            
        // Защита на отсутствие значения
        if name == nil || name == "" {
            presenter?.showError()
            return
        }
        
        guard let currentFirstAidKitID = currentFirstAidKit?.objectID else {
            Logger.error("Не удалось найти ID объекта")
            return
        }
        
        coreDataService?.performSave { [weak self] context in
            var currentFirstAidKit: DBFirstAidKit?
            
            self?.coreDataService?.fetchFirstAidKits(from: context, completion: { result in
                switch result {
                case .success(let firstAidKits):
                    if let firstAidKit = firstAidKits.filter({ $0.objectID == currentFirstAidKitID }).first {
                        currentFirstAidKit = firstAidKit
                    } else {
                        Logger.warning("Объект не найден")
                    }
                case .failure(let error):
                    Logger.error(error.localizedDescription)
                }
            })
            
            // Расширение doubleValue возвращает 0, но с 0 будет краш приложения
            // при открытии такого лекарства. По этому, значение по умолчанию
            // для stepCountForStepper равняется 1.
            let medicine = MedicineModel(
                dateCreated: Date(),
                title: name ?? "",
                type: type,
                amount: amount?.doubleValue ?? 0,
                stepCountForStepper: countSteps?.doubleValue ?? 1,
                expiryDate: expiryDate?.toDate()
            )
            
            // Проверяем на попытку создания нового лекарства
            if let dbMedicine = dbMedicine {
                self?.coreDataService?.updateMedicine(
                    dbMedicine,
                    newData: medicine,
                    context: context
                )
            } else {
                self?.coreDataService?.createMedicine(
                    medicine,
                    currentFirstAidKit: currentFirstAidKit,
                    context: context
                )
            }
            
            self?.presenter?.returnToBack()
        }
    }
}
