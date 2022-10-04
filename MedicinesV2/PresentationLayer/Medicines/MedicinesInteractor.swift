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
    /// - Обновление происходит в глобальном потоке через 1 секунды после срабатывания метода.
    ///   Это необходимо для того, чтобы данные в базе успели обновится и я получил новые данные.
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
        coreDataService?.performSave { [weak self] context in
            self?.notificationManager?.deleteNotification(for: medicine)
            self?.coreDataService?.delete(medicine, context: context)
            self?.updateNotificationBadge()
            // TODO: (#MED-142) Придумать, как работать с многопоточкой и обновить плейсхолдер после удаления данных
            // Сейчас не совсем оптимально. Нужно обновлять, сразу после того как произошло обновление и делать это плавно с анимацией.
        }
    }
    
    func updateNotificationBadge() {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
            let data = self.coreDataService?.fetchRequest(
                String(describing: DBMedicine.self)
            ) as? [DBMedicine]
            self.notificationManager?.setupBadgeForAppIcon(data: data)
        }
    }
}
