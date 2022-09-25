//
//  MedicinesInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

/// Протокол для работы с бизнес логикой модуля
protocol MedicinesBusinessLogic {
    /// Метод для обновления значка уведомлений на иконке приложения
    func updateNotificationBadge()
    /// Метод для удаления данных из БД
    /// Запрос на обновление данных должен происходить
    /// в момент возврата на экран со списком лекарств.
    /// - Parameter medicine: принимает лекарство, которое необходимо удалить из БД
    func delete(medicine: DBMedicine)
}

final class MedicinesInteractor {
    
    // MARK: - Public properties
    
    /// Ссылка на презентер
    weak var presenter: MedicinesPresentationLogiс?
    var coreDataService: ICoreDataService?
    var notificationManager: INotificationMedicineManager?
}

// MARK: - BusinessLogic

extension MedicinesInteractor: MedicinesBusinessLogic {
    func delete(medicine: DBMedicine) {
        coreDataService?.performSave({ [weak self] context in
            self?.notificationManager?.deleteNotification(for: medicine)
            self?.coreDataService?.delete(medicine, context: context)
        })
    }
    
    func updateNotificationBadge() {
        let data = coreDataService?.fetchRequest(String(describing: DBMedicine.self)) as? [DBMedicine]
        notificationManager?.setupBadgeForAppIcon(data: data)
    }
}
