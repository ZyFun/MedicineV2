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
    func delete(medicine: DBMedicine)
}

final class MedicinesInteractor {
    
    // MARK: - Public properties
    
    /// Ссылка на презентер
    weak var presenter: MedicinesPresentationLogiс?
    var coreDataService: ICoreDataService?
    var notificationService: INotificationService?
    
    // MARK: - Private methods
    
    /// Метод для очистки очереди уведомлений
    /// - Parameter medicine: принимает лекарство, уведомления для которого будут удалены.
    private func deleteNotifications(for medicine: DBMedicine) {
        if let medicineName = medicine.title {
            notificationService?.notificationCenter.removePendingNotificationRequests(withIdentifiers: [medicineName])
            
            Logger.info("Уведомление для лекарства \(medicineName) удалено из очереди")
        }
    }
}

// MARK: - BusinessLogic

extension MedicinesInteractor: MedicinesBusinessLogic {
    func delete(medicine: DBMedicine) {
        coreDataService?.performSave({ [weak self] context in
            self?.deleteNotifications(for: medicine)
            self?.coreDataService?.delete(medicine, context: context)
        })
    }
    
    func requestData() {
        let data = coreDataService?.fetchRequest(String(describing: DBMedicine.self)) as? [DBMedicine]
        setupBadgeForAppIcon(data: data) // TODO: Должно вызываться в момент сохранения
        updateNotificationQueueExpiredMedicine(data: data) // TODO: Должно вызываться в момент сохранения
    }
    
    // TODO: КОд из старого приложения, нужно доработать
    /// Метод для обновления очереди уведомлений.
    /// - Добавление в очередь центра уведомлений: функция пробегается циклом по массиву лекарств и получает данные с именем лекарства и датой срока его годности. Далее эти данные принимаются функцией sendNotificationExpiredMedicine в классе Notifications и добавляются в очередь уведомлений.
    private func updateNotificationQueueExpiredMedicine(data: [DBMedicine]?) {
        guard let data = data else {
            Logger.warning("В базе еще нет лекарств")
            return
        }
        
        data.forEach({ [weak self] medicine in
            if let medicineName = medicine.title {
                self?.notificationService?.sendNotificationExpiredMedicine(reminder: medicine.expiryDate, nameMedicine: medicineName)
            }
        })
    }
    
    // TODO: КОд из старого приложения, нужно доработать
    /// Метод установки бейджа с количеством просроченных лекарств на иконку приложения.
    /// - Установка бейджа на иконку: функция пробегается циклом по массиву лекарств. И если в базе есть лекарства с просроченным сроком годности, то добавляется +1 к значению на бейдже за каждое лекарство с просроченным сроком годности. Если таких лекарств нет, бейдж сбрасывается на 0.
    private func setupBadgeForAppIcon(data: [DBMedicine]?) {
        guard let data = data else {
            Logger.warning("В базе еще нет лекарств")
            return
        }
        
        var expiredMedicinesCount = 0 // Создаём свойство, для подсчета просроченных лекарств
        
        // Проходимся циклом по массиву базы лекарств и прибавляем +1 к счетчику
        data.forEach { [weak self] medicine in
            if Date() >= medicine.expiryDate ?? Date() { // Если есть просроченное лекарство делаем +1.
                
                expiredMedicinesCount += 1
                self?.notificationService?.setupBadge(count: expiredMedicinesCount) // Отправляем это значение в метод класса уведомлений
                
            } else {
                self?.notificationService?.setupBadge(count: expiredMedicinesCount) // Если просрочек нет, сбрасываем на 0. То есть присваиваем изначальное значение равное 0
            }
        }
    }
}
