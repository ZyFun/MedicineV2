//
//  MedicinesInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

/// Протокол для работы с бизнес логикой модуля
protocol MedicinesBusinessLogic {
    /// Метод для получения объектов из БД в виде массива.
    /// - Запрос должен происходить при первичной загрузке приложения,
    /// и при создании или удалении данных (для корректной работы с массивом в таблице)
    func requestData()
    
    /// Метод для удаления данных из БД
    /// Запрос на обновление данных должен происходить
    /// в момент возврата на экран со списком лекарств.
    /// - Parameter medicine: принимает лекарство, которое необходимо удалить из БД
    func deleteData(medicine: Medicine)
}

final class MedicinesInteractor {
    /// Ссылка на презентер
    weak var presenter: MedicinesPresentationLogiс?
    
    // TODO: На данный момент остальные методы еще не перенесены, по этому кажется что он тут не нужен. Будет нужен как только всё будет правильно переписано под архитектуру.
    /// Данные с массивом аптечек.
    ///  - Используется для того, чтобы хранить в себе текущие данные после запроса к базе
    ///  данных, и уменьшить количество обращений к базе.
    var data: [Medicine]?
}

// MARK: - BusinessLogic
extension MedicinesInteractor: MedicinesBusinessLogic {
    func deleteData(medicine: Medicine) {
        StorageManager.shared.deleteObject(medicine)
    }
    
    func requestData() {
        data = StorageManager.shared.fetchRequest(String(describing: Medicine.self)) as? [Medicine]
        presenter?.presentData(data)
    }
}
