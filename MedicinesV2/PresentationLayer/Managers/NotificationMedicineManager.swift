//
//  NotificationMedicineManager.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 24.09.2022.
//

import Foundation

protocol INotificationMedicineManager {
    func updateNotificationQueueExpiredMedicine(data: [DBMedicine]?)
    func setupBadgeForAppIcon(data: [DBMedicine]?)
    /// Метод для очистки очереди уведомлений
    /// - Parameter medicine: принимает лекарство, уведомления для которого будут удалены.
    func deleteNotification(for medicine: DBMedicine)
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
            
            Logger.info("Уведомление для лекарства \(medicineName) удалено из очереди")
        }
    }
    
    // TODO: (#Update) Код из старого приложения, нужно доработать
    /// Метод для обновления очереди уведомлений.
    /// - Добавление в очередь центра уведомлений: функция пробегается циклом по массиву
    ///   лекарств и получает данные с именем лекарства и датой срока его годности. Далее эти
    ///   данные принимаются функцией sendNotificationExpiredMedicine в классе Notifications
    ///   и добавляются в очередь уведомлений.
    func updateNotificationQueueExpiredMedicine(data: [DBMedicine]?) {
        guard let data = data else {
            Logger.warning("В базе еще нет лекарств")
            return
        }
        
        data.forEach({ [weak self] medicine in
            if let medicineName = medicine.title {
                self?.notificationService.sendNotificationExpiredMedicine(reminder: medicine.expiryDate, nameMedicine: medicineName)
            }
        })
    }
    
    // TODO: (#Update) Код из старого приложения, нужно доработать
    /// Метод установки бейджа с количеством просроченных лекарств на иконку приложения.
    /// - Установка бейджа на иконку: функция пробегается циклом по массиву лекарств.
    ///   И если в базе есть лекарства с просроченным сроком годности, то добавляется +1 к
    ///   значению на бейдже за каждое лекарство с просроченным сроком годности. Если таких
    ///   лекарств нет, бейдж сбрасывается на 0.
    func setupBadgeForAppIcon(data: [DBMedicine]?) {
        guard let data = data else {
            Logger.warning("В базе еще нет лекарств")
            return
        }
        
        var expiredMedicinesCount = 0
        
        // TODO: (#Update) Сбросить счетчик на 0, если лекарств или аптечек нет совсем
        
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
