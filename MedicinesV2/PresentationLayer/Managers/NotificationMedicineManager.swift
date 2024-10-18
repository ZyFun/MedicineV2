//
//  NotificationMedicineManager.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 24.09.2022.
//

import Foundation
import DTLogger

protocol INotificationMedicineManager {
    /// Метод для добавления уведомления о просроченном лекарстве в очередь центра уведомлений
    /// - Parameter data: принимает лекарство, уведомления для которого будут добавлены.
    /// - Метод используется при работе с моделью данных
    func addToQueueNotificationExpiredMedicine(data: MedicineModel)
    
    /// Метод для добавления уведомления о просроченном лекарстве в очередь центра уведомлений
    /// - Parameter data: принимает лекарство, уведомления для которого будут добавлены.
    /// - Метод используется при работе с базой данных
    func addToQueueNotificationExpiredMedicine(data: DBMedicine)
    
    /// Метод для удаления уведомления из очереди центра уведомлений
    /// - Parameter medicine: принимает лекарство, уведомление для которого будет удалено.
    func deleteNotification(for medicine: DBMedicine)

	/// Метод для очистки всех уведомлений из очереди
	func clearAllNotifications()

    /// Метод установки бейджа с количеством просроченных лекарств на иконку приложения.
    /// - Parameter data: Принимает лекарства для поиска в них просроченных лекарств
    func setupBadgeForAppIcon(data: [DBMedicine]?)
    
    /// Метод для установки и сохранения времени уведомления
    /// - Parameters:
    ///   - hourNotifiable: принимает час, в который будет приходить уведомление
    ///   - isRepeat: принимает Bool для возможности настройки повтора уведомления.
    func setTimeForNotification(hourNotifiable: Int, isRepeat: Bool) throws
    
    /// Метод для получения времени уведомления
    /// - Нужно вызывать перед тем как будет происходить добавление уведомления в очередь уведомлений.
    func getTimeForNotification() throws
}

final class NotificationMedicineManager {
    
    // MARK: - Dependencies
    
    let notificationService: INotificationService
    let notificationSettingService: NotificationSettings
    private let logger: DTLogger
    
    // MARK: - Private properties
    
    private var hourNotifiable: Int
    private var isRepeat: Bool
    
    // MARK: - Initializer
    
    /// - Parameters:
    ///   - notificationService: сервис уведомлений
    ///   - notificationSettingService: сервис настроек
    ///   - logger: сервис ведения логов
    ///   - hourNotifiable: час отображения уведомлений. По умолчанию установлено на 20 часов
    ///   - isRepeat: настройка повторения уведомления. По умолчанию true и уведомления повторяются
    init(
        notificationService: INotificationService,
        notificationSettingService: NotificationSettings,
        logger: DTLogger,
        hourNotifiable: Int = 20,
        isRepeat: Bool = true
        
    ) {
        self.notificationService = notificationService
        self.notificationSettingService = notificationSettingService
        self.logger = logger
        self.hourNotifiable = hourNotifiable
        self.isRepeat = isRepeat
    }
}

// MARK: - INotificationMedicineManager

extension NotificationMedicineManager: INotificationMedicineManager {
	func clearAllNotifications() {
		notificationService.notificationCenter.removeAllPendingNotificationRequests()
		logger.log(.info, "Все уведомления были очищены")
	}

    func deleteNotification(for medicine: DBMedicine) {
        guard let dateCreated = medicine.dateCreated else {
            fatalError("Дата создания лекарства должна быть обязательно")
        }
        
        if let medicineName = medicine.title {
            let dateCreated = dateCreated.toString(format: "_MM-dd-yyyy_HH:mm:ss")
            let identifier = medicineName + dateCreated
            notificationService.notificationCenter.removePendingNotificationRequests(
                withIdentifiers: [identifier]
            )
            
            logger.log(.info, "Уведомление для лекарства \(identifier) удалено из очереди")
        }
    }
    
    func addToQueueNotificationExpiredMedicine(data: MedicineModel) {
        try? getTimeForNotification()
        notificationService.sendNotificationExpiredMedicine(
            reminder: data.expiryDate,
            nameMedicine: data.title,
            dateCreated: data.dateCreated,
            isRepeat: isRepeat,
            hourNotifiable: hourNotifiable
        )
    }
    
    func addToQueueNotificationExpiredMedicine(data: DBMedicine) {
        guard let title = data.title else {
            fatalError("Название лекарства должно быть обязательным")
        }
        guard let dateCreated = data.dateCreated else {
            fatalError("Дата создания лекарства должна быть обязательной")
        }
        
        try? getTimeForNotification()
        notificationService.sendNotificationExpiredMedicine(
            reminder: data.expiryDate,
            nameMedicine: title,
            dateCreated: dateCreated,
            isRepeat: isRepeat,
            hourNotifiable: hourNotifiable
        )
    }
    
    func getTimeForNotification() throws {
        do {
            guard let data = try notificationSettingService.getNotificationSettings() else { return }
            hourNotifiable = data.hourNotifiable
            isRepeat = data.isRepeat
        } catch {
            logger.log(.error, error.localizedDescription)
            // TODO: () Доделать обработку ошибок и уведомлять о ней пользователя
        }
    }
    
    func setTimeForNotification(hourNotifiable: Int, isRepeat: Bool) throws {
        // TODO: () Дописать вызов для обновления времени обновления для всех лекарств
        
        do {
            try notificationSettingService.saveNotificationSettings(hourNotifiable: hourNotifiable, isRepeat: isRepeat)
        } catch {
            logger.log(.error, error.localizedDescription)
            // TODO: () Доделать обработку ошибок и уведомлять о ней пользователя
        }
    }
    
    func setupBadgeForAppIcon(data: [DBMedicine]?) {
        guard let data = data else {
            logger.log(.warning, "В базе еще нет лекарств")
            return
        }
        
        // TODO: (MED-170) Логику ниже делать методом сервиса кордаты
        // к примеру назвать fetchCountExpiredMedicines
        var expiredMedicinesCount = 0
        
        data.forEach { medicine in
            if let expiryDate = medicine.expiryDate, Date() >= expiryDate {
                expiredMedicinesCount += 1
            }
        }
        notificationService.setupBadge(count: expiredMedicinesCount)
        
        logger.log(.info, "Бейдж на иконке приложения обновлён")
    }
}
