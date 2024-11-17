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
        let medicines = self.coreDataService?.fetchRequest(String(describing: DBMedicine.self)) as? [DBMedicine]
		guard let medicines else { return }
		for medicine in medicines {
			if let expiryDate = medicine.expiryDate, Date() >= expiryDate {
				presenter?.updateExpiredMedicinesLabel()
				return
			}
		}
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
					self?.presenter?.operationComplete(result: .success(()))
                case .failure(let error):
                    self?.logger?.log(.error, error.localizedDescription)
					self?.presenter?.operationComplete(result: .failure(error))
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
		DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 1) {
            let data = self.coreDataService?.fetchRequest(String(describing: DBMedicine.self)) as? [DBMedicine]
            self.notificationManager?.setupBadgeForAppIcon(data: data)
        }
    }

	func updateAllNotifications() {
		let medicines = coreDataService?.fetchRequest(String(describing: DBMedicine.self)) as? [DBMedicine]
		notificationManager.clearAllNotifications()
		medicines?.forEach { medicine in
			logger?.log(.info, "Начало обработки уведомления для лекарства: \(medicine.title ?? "NoName")")
			notificationManager?.addToQueueNotificationExpiredMedicine(data: medicine)
			logger?.log(.info, "Уведомление в очереди обновлено")
		}
		presenter?.dismissSplashScreen()
	}
}
