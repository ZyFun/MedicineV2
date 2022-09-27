//
//  NotificationMedicineManager.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 24.09.2022.
//

import Foundation

protocol INotificationMedicineManager {
    /// Метод для добавления уведомления о просроченном лекарстве в очередь центра уведомлений
    /// - Parameter data: принимает лекарство, уведомления для которого будут добавлены.
    func addToQueueNotificationExpiredMedicine(data: MedicineModel)
    /// Метод для удаления уведомления из очереди центра уведомлений
    /// - Parameter medicine: принимает лекарство, уведомление для которого будет удалено.
    func deleteNotification(for medicine: DBMedicine)
    /// Метод установки бейджа с количеством просроченных лекарств на иконку приложения.
    /// - Parameter data: Принимает лекарства для поиска в них просроченных лекарств
    func setupBadgeForAppIcon(data: [DBMedicine]?)
}

final class NotificationMedicineManager {
    
    let notificationService: INotificationService
    
    init(notificationService: INotificationService) {
        self.notificationService = notificationService
    }
}

// MARK: - Interface

extension NotificationMedicineManager: INotificationMedicineManager {
    func deleteNotification(for medicine: DBMedicine) {
        if let medicineName = medicine.title {
            notificationService.notificationCenter.removePendingNotificationRequests(withIdentifiers: [medicineName])
            
            CustomLogger.info("Уведомление для лекарства \(medicineName) удалено из очереди")
        }
    }
    
    func addToQueueNotificationExpiredMedicine(data: MedicineModel) {
        notificationService.sendNotificationExpiredMedicine(
            reminder: data.expiryDate,
            nameMedicine: data.title
        )
    }
    
    func setupBadgeForAppIcon(data: [DBMedicine]?) {
        guard let data = data else {
            CustomLogger.warning("В базе еще нет лекарств")
            return
        }
        
        var expiredMedicinesCount = 0
        
        // TODO: (MED-135) Сбросить счетчик на 0, если лекарств или аптечек нет совсем
        
        data.forEach { [weak self] medicine in
            if Date() >= medicine.expiryDate ?? Date() {
                expiredMedicinesCount += 1
                self?.notificationService.setupBadge(count: expiredMedicinesCount)
            } else {
                self?.notificationService.setupBadge(count: expiredMedicinesCount)
            }
        }
    }
}
