//
//  MedicinesInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

protocol BusinessLogic {
    func requestData()
    
    /// Метод для удаления данных из БД
    /// Запрос на обновление данных должен происходить
    /// в момент возврата на экран со списком лекарств.
    /// - Parameter medicine: принимает лекарство, которое необходимо удалить из БД
    func deleteData(medicine: Medicine)
}

final class MedicinesInteractor {
    
    weak var presenter: PresentationLogiс?
    
    var data: [Medicine]?
}

// MARK: - BusinessLogic
extension MedicinesInteractor: BusinessLogic {
    func deleteData(medicine: Medicine) {
        StorageManager.shared.deleteObject(medicine)
    }
    
    func requestData() {
        data = StorageManager.shared.fetchRequest(String(describing: Medicine.self)) as? [Medicine]
        presenter?.presentData(data)
    }
}
