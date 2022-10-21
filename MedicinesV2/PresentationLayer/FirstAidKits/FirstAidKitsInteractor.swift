//
//  FirstAidKitsInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import Foundation

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
    /// - Используется для того, чтобы все уведомления приходили повторно
    /// - Лучше вызывать этот метод только после синхронизации с облаком при
    ///   первом запуске, или при обновлении системы. Не знаю как обновляется
    ///   очередь уведомлений если система была обновлена. Нужно это протестировать
    ///   а до этого момента оставить и не использовать
    func updateAllNotifications()
}

final class FirstAidKitInteractor {
    
    // MARK: - Public properties
    
    /// Ссылка на презентер
    weak var presenter: FirstAidKitsPresentationLogic?
    /// Сервис UserNotifications
    var notificationManager: INotificationMedicineManager!
    var coreDataService: ICoreDataService?
    
    // MARK: - Private methods
    
    /// Метод для очистки очереди уведомлений
    /// - Parameter firstAidKit: принимает аптечку, в которой будут удалены лекарства и
    ///                          уведомления для них.
    private func deleteNotifications(for firstAidKit: DBFirstAidKit) {
        firstAidKit.medicines?.forEach { medicine in
            guard let medicine = medicine as? DBMedicine else {
                CustomLogger.error("Ошибка каста до DBMedicine")
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
            CustomLogger.error("Не удалось получить аптечки из базы")
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
            CustomLogger.info("Плейсхолдер скрыт после добавления аптечки")
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
                    CustomLogger.error(error.localizedDescription)
                }
            }
        }
    }
    
    private func updatePlaceholder(for firstAidKits: [DBFirstAidKit]) {
        if firstAidKits.isEmpty {
            presenter?.showPlaceholder()
            CustomLogger.info("Плейсхолдер отображен после удаления аптечки")
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
                                CustomLogger.error("Ошибка каста до DBMedicine")
                                return
                            }
                            self?.notificationManager.addToQueueNotificationExpiredMedicine(
                                data: medicine
                            )
                            CustomLogger.info("Уведомление в очереди обновлено")
                        }
                    }
                    
                    self?.presenter?.dismissSplashScreen()
                case .failure(let error):
                    CustomLogger.error(error.localizedDescription)
                }
            }
        }
    }
}
