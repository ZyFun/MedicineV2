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
}

final class FirstAidKitInteractor {
    
    // MARK: - Public properties
    
    /// Ссылка на презентер
    weak var presenter: FirstAidKitsPresentationLogic?
    /// Сервис UserNotifications
    var notificationService: INotificationService!
    var coreDataService: ICoreDataService?
    
    // MARK: - Private methods
    
    /// Метод для очистки очереди уведомлений
    /// - Parameter firstAidKit: принимает аптечку, уведомления для которой будут удалены.
    private func deleteNotifications(for firstAidKit: DBFirstAidKit) {
        firstAidKit.medicines?.forEach { medicine in
            guard let medicine = medicine as? DBMedicine else {
                CustomLogger.error("Ошибка каста до DBMedicine")
                return
            }
            
            if let medicineName = medicine.title {
                notificationService.notificationCenter.removePendingNotificationRequests(withIdentifiers: [medicineName])
                
                CustomLogger.info("Уведомление для лекарства \(medicineName) удалено из очереди")
            }
        }
    }
}

// MARK: - Бизнес логика модуля

extension FirstAidKitInteractor: FirstAidKitsBusinessLogic {
    
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
    
    // MARK: - CRUD methods
    
    func createData(_ firstAidKitName: String) {
        coreDataService?.performSave({ [weak self] context in
            self?.coreDataService?.create(firstAidKitName, context: context)
            self?.presenter?.hidePlaceholder()
            CustomLogger.info("Плейсхолдер скрыт после добавления аптечки")
        })
    }

    func updateData(_ firstAidKit: DBFirstAidKit, newName: String) {
        coreDataService?.performSave({ context in
            self.coreDataService?.update(firstAidKit, newName: newName, context: context)
        })
    }
    
    func delete(firstAidKit: DBFirstAidKit) {
        coreDataService?.performSave { [weak self] context in
            self?.deleteNotifications(for: firstAidKit)
            self?.coreDataService?.delete(firstAidKit, context: context)
            
            self?.coreDataService?.fetchFirstAidKits(from: context) { result in
                switch result {
                case .success(let firstAidKits):
                    self?.updatePlaceholder(for: firstAidKits)
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
}
