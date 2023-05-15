//
//  SettingsService.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 30.03.2023.
//

import Foundation
import DTLogger

/// Протокол с методами сохранения настроек сортировки
protocol SortableSettings {
    typealias FieldSorting = SettingsService.Fields
    typealias SortDirection = SettingsService.SortDirection
    
    /// Метод сохраняет направление сортировки
    /// - Parameter ascending: выбор из enum типа направления, вверх или вниз
    func saveSortSetting(ascending: SortDirection)
    /// Метод получает направление сортировки
    /// - Returns: если ключ сортировки не был найден в памяти, возвращается true как настройка
    /// направления по умолчанию
    func getSortAscending() -> Bool
    
    /// Метод сохраняет название поля сортировки
    /// - Parameter field: выбор поля сортировки из enum
    func saveSortSetting(field: FieldSorting)
    /// Метод получает название поля сортировки
    /// - Returns: если поле сортировки не было установлено, по умолчанию возвращает сортировку
    /// по названию лекарства
    func getSortField() -> String
    
    /// Метод удаляет все ключи сортировки из памяти. После этого сортировка возвращает значения
    /// установленные по умолчанию
    func deleteSortSettings()
}

/// Протокол с методами сохранения настроек уведомлений
protocol NotificationSettings {
    /// Метод для сохранения настроек уведомления
    /// - Parameters:
    ///   - hourNotifiable: принимает час, в который будет приходить уведомление
    ///   - isRepeat: принимает Bool для возможности настройки повтора уведомления.
    ///   При значении true уведомления повторяются.
    ///   - Может выбросить ошибку
    func saveNotificationSettings(hourNotifiable: Int, isRepeat: Bool) throws
    
    /// Метод для чтения сохраненных параметров настройки уведомлений. Если настройки еще не
    /// сохранялись, возвращает nil. В этом случае настройки нужно задать по умолчанию.
    /// - Returns: Возвращает опциональный ``NotificationSettingModel``
    ///   - Может выбросить ошибку
    func getNotificationSettings() throws -> NotificationSettingModel?
    
    /// Удаляет все объекты с ключём notification
    func deleteNotificationSettings()
}

final class SettingsService {
    static let shared = SettingsService()
    
    private let userDefaults = UserDefaults.standard
    
    /// Ключи для сохранения в ``UserDefaults``
    private enum Key: String {
        case sortField
        case sortAscending
        case notification
    }
    
    private init() {}
}

// MARK: - SortableSettings

extension SettingsService: SortableSettings {
    /// Поля, по которым будет задана сортировка
    enum Fields {
        case title
        case dateCreated
        case expiryDate
        
        var type: String {
            switch self {
            case .title:
                return #keyPath(DBMedicine.title)
            case .dateCreated:
                return #keyPath(DBMedicine.dateCreated)
            case .expiryDate:
                return #keyPath(DBMedicine.expiryDate)
            }
        }
    }
    
    /// Направление сортировки
    enum SortDirection {
        case up
        case down
        
        var isAscending: Bool {
            switch self {
            case .up:
                return true
            case .down:
                return false
            }
        }
    }
    
    func saveSortSetting(ascending: SortDirection) {
        DispatchQueue.global(qos: .utility).async {
            let key = Key.sortAscending.rawValue
            let value = ascending.isAscending
            self.userDefaults.set(value, forKey: key)
            SystemLogger.info("Направление сортировки сохранено: \(ascending)")
        }
    }
    
    func getSortAscending() -> Bool {
        if userDefaults.object(forKey: Key.sortAscending.rawValue) == nil {
            SystemLogger.warning("Установлено направление по умолчанию")
            return true
        } else {
            return userDefaults.bool(forKey: Key.sortAscending.rawValue)
        }
    }
    
    func saveSortSetting(field: FieldSorting) {
        DispatchQueue.global(qos: .utility).async {
            self.userDefaults.set(field.type, forKey: Key.sortField.rawValue)
            SystemLogger.info("Поле сортировки сохранено: \(field)")
        }
    }
    
    func getSortField() -> String {
        let field = userDefaults.string(forKey: Key.sortField.rawValue)
        guard let field else {
            SystemLogger.warning("Установлено поле по умолчанию")
            return #keyPath(DBMedicine.title)
        }
        
        return field
    }
    
    func deleteSortSettings() {
        DispatchQueue.global(qos: .utility).async {
            self.userDefaults.removeObject(forKey: Key.sortField.rawValue)
            self.userDefaults.removeObject(forKey: Key.sortAscending.rawValue)
            SystemLogger.info("Направление сортировки сброшено")
        }
    }
}

// MARK: - NotificationSettings

extension SettingsService: NotificationSettings {    
    func saveNotificationSettings(hourNotifiable: Int, isRepeat: Bool) throws {
        let notification = NotificationSettingModel(hourNotifiable: hourNotifiable, isRepeat: isRepeat)
        
        do {
            let encoded = try notification.encode()
            DispatchQueue.global(qos: .utility).async {
                self.userDefaults.set(encoded, forKey: Key.notification.rawValue)
                SystemLogger.info("Время уведомлений сохранено")
            }
        } catch {
            throw error
        }
    }
    
    func getNotificationSettings() throws -> NotificationSettingModel? {
        guard let data = userDefaults.data(forKey: Key.notification.rawValue) else {
            SystemLogger.warning("Время и повтор уведомлений установлены по умолчанию")
            return nil
        }
        
        do {
            let setting = try NotificationSettingModel.decode(from: data)
            return NotificationSettingModel(
                hourNotifiable: setting.hourNotifiable,
                isRepeat: setting.isRepeat
            )
        } catch {
            throw error
        }
    }
    
    func deleteNotificationSettings() {
        DispatchQueue.global(qos: .utility).async {
            self.userDefaults.removeObject(forKey: Key.notification.rawValue)
            SystemLogger.info("Время уведомлений сброшено")
        }
    }
}
