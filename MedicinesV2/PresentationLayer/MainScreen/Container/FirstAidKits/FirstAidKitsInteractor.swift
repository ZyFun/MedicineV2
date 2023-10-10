//
//  FirstAidKitsInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import Foundation
import DTLogger

/// Протокол для работы с бизнес логикой модуля
protocol FirstAidKitsBusinessLogic {
    /// Метод для обновления состояния плейсхолдера
    /// - Используется для скрытия или отображения плейсхолдера
    /// - Если в базе есть аптечки, скрывается, иначе - отображается
    func updatePlaceholder()
    /// Метод для поиска просроченных лекарств в аптечке
    /// - Используется только для запуска  обновления лейбла в списке аптечек, перезапуская
    /// таблицу, если есть просроченные лекарства в базе.
    func searchExpiredMedicines()
    /// Метод для создания новой аптечки.
    /// - Parameter firstAidKit: принимает имя аптечки.
    func createData(_ firstAidKitName: String)
    /// Метод для редактирования аптечки
    /// - Parameters:
    ///   - firstAidKit: принимает аптечку, которую необходимо отредактировать
    ///   - newName: принимает новое имя для аптечки
    func updateData(_ firstAidKit: DBFirstAidKit, newName: String)
    /// Метод для удаления данных из БД
    /// - Parameter firstAidKit: принимает аптечку, которую необходимо удалить из БД
    func delete(firstAidKit: DBFirstAidKit)
    /// Метод для обновления бейджей на иконке приложения
    /// - Используется для обновления бейджей при входе в приложение
    func updateNotificationBadge()
    /// Метод для обновления всех уведомлений
    /// - Используется для обновления всех уведомлений после того, как были сохранены настройки.
    /// - warning: Сейчас вызывается каждый раз и при запуске приложения, и при возврате с любого экрана.
    /// Такого быть не должно и это надо изменить. Вызываться должен только по необходимости.
    /// - important: Метод так же закрывает сплешскрин, после того как все уведомления для лекарств были обновлены.
    func updateAllNotifications()
}

final class FirstAidKitInteractor {
    
    // MARK: - Public properties
    
    /// Ссылка на презентер
    weak var presenter: FirstAidKitsPresentationLogic?
    
    // MARK: - Dependencies
    
    /// Сервис UserNotifications
    var notificationManager: INotificationMedicineManager!
    var coreDataService: ICoreDataService?
    var logger: DTLogger?
    
    // MARK: - Private methods
    
    /// Метод для очистки очереди уведомлений
    /// - Parameter firstAidKit: принимает аптечку, в которой будут удалены лекарства и
    ///                          уведомления для них.
    private func deleteNotifications(for firstAidKit: DBFirstAidKit) {
        firstAidKit.medicines?.forEach { medicine in
            guard let medicine = medicine as? DBMedicine else {
                logger?.log(.error, "Ошибка каста до DBMedicine")
                return
            }
            
            notificationManager.deleteNotification(for: medicine)
        }
    }
}

// MARK: - Бизнес логика модуля

extension FirstAidKitInteractor: FirstAidKitsBusinessLogic {
    
    // MARK: - Interface update
    
    func updatePlaceholder() {
        guard let data = coreDataService?.fetchRequest(
            String(describing: DBFirstAidKit.self)
        ) else {
            logger?.log(.error, "Не удалось получить аптечки из базы")
            return
        }
        
        if !data.isEmpty {
            presenter?.hidePlaceholder()
        } else {
            presenter?.showPlaceholder()
        }
    }
    
    func searchExpiredMedicines() {
        // TODO: (MED-170) Логику ниже делать методом сервиса кордаты
        // к примеру назвать fetchCountExpiredMedicines
        var expiredMedicinesCount = 0
        let medicines = self.coreDataService?.fetchRequest(String(describing: DBMedicine.self)) as? [DBMedicine]

        medicines?.forEach { medicine in
            if let expiryDate = medicine.expiryDate, Date() >= expiryDate {
                expiredMedicinesCount += 1
            }
        }

        presenter?.updateExpiredMedicinesLabel()
    }
    
    // MARK: - CRUD methods
    
    func createData(_ firstAidKitName: String) {
        coreDataService?.performSave { [weak self] context in
            self?.coreDataService?.create(firstAidKitName, context: context)
            self?.presenter?.hidePlaceholder()
            self?.logger?.log(.info, "Плейсхолдер скрыт после добавления аптечки")
        }
    }

    func updateData(_ firstAidKit: DBFirstAidKit, newName: String) {
        coreDataService?.performSave { context in
            self.coreDataService?.update(firstAidKit, newName: newName, context: context)
        }
    }
    
    func delete(firstAidKit: DBFirstAidKit) {
        coreDataService?.performSave { [weak self] context in
            self?.deleteNotifications(for: firstAidKit)
            self?.coreDataService?.delete(firstAidKit, context: context)
            
            self?.coreDataService?.fetch(DBFirstAidKit.self, from: context) { result in
                switch result {
                case .success(let firstAidKits):
                    self?.updatePlaceholder(for: firstAidKits)
                    self?.updateNotificationBadge()
                case .failure(let error):
                    self?.logger?.log(.error, error.localizedDescription)
                }
            }
        }
    }
    
    private func updatePlaceholder(for firstAidKits: [DBFirstAidKit]) {
        if firstAidKits.isEmpty {
            presenter?.showPlaceholder()
            logger?.log(.info, "Плейсхолдер отображен после удаления аптечки")
        }
    }
    
    // MARK: - Notifications
    
    func updateNotificationBadge() {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
            let data = self.coreDataService?.fetchRequest(String(describing: DBMedicine.self)) as? [DBMedicine]
            self.notificationManager?.setupBadgeForAppIcon(data: data)
        }
    }
    
    // TODO: (#Update) Не самый оптимальный способ в плане алгоритмов. Нужно пересмотреть, возможно есть способ лучше.
    // FIXME: Получить просто список лекарств без привязки к текущей аптечке.
    func updateAllNotifications() {
        coreDataService?.performSave { [weak self] context in
            self?.coreDataService?.fetch(DBFirstAidKit.self, from: context) { result in
                switch result {
                case .success(let dbFirstAidKits):
                    dbFirstAidKits.forEach { dbFirstAidKit in
                        dbFirstAidKit.medicines?.forEach { medicine in
                            guard let medicine = medicine as? DBMedicine else {
                                self?.logger?.log(.error, "Ошибка каста до DBMedicine")
                                return
                            }
                            self?.logger?.log(.info, "Уведомление в очереди для `\(medicine.title ?? "⚠️")` будет обновлено")
                            self?.notificationManager.addToQueueNotificationExpiredMedicine(
                                data: medicine
                            )
                        }
                    }
                    
                    self?.presenter?.dismissSplashScreen()
                case .failure(let error):
                    self?.logger?.log(.error, error.localizedDescription)
                }
            }
        }
    }
}
