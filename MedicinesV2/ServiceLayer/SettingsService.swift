//
//  SettingsService.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 30.03.2023.
//

import Foundation
import DTLogger

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

final class SettingsService {
    private let userDefaults = UserDefaults.standard
}

// MARK: - SortableSettings

extension SettingsService: SortableSettings {
    private enum Key: String {
        case sortField
        case sortAscending
    }
    
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
