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
        let currentDate = Date()
        var expiredMedicinesCount = 0
        
        data.forEach { medicine in
            if currentDate >= medicine.expiryDate ?? currentDate {
                expiredMedicinesCount += 1
            }
        }
        notificationService.setupBadge(count: expiredMedicinesCount)
        
        CustomLogger.info("Бейдж на иконке приложения обновлён")
    }
}
