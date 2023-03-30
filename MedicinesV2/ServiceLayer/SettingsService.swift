//
//  SettingsService.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 30.03.2023.
//

import Foundation

protocol SortableSettings {
    typealias Key = SettingsService.Key
    
    func saveSetting(ascending: Bool, with key: Key)
    func getAscending(with key: Key) -> Bool
    func delete(with key: Key)
}

final class SettingsService {
    private let userDefaults = UserDefaults()
    
    enum Key: String {
        case sortField
        case sortAscending
    }
}

// MARK: - SortableSettings

extension SettingsService: SortableSettings {
    func saveSetting(ascending: Bool, with key: Key) {
        DispatchQueue.global(qos: .background).async {
            self.userDefaults.set(ascending, forKey: key.rawValue)
            
            SystemLogger.info("Направление сортировки сохранено: \(ascending)")
        }
    }
    
    func getAscending(with key: Key) -> Bool {
        userDefaults.bool(forKey: key.rawValue)
    }
    
    func delete(with key: Key) {
        DispatchQueue.global(qos: .background).async {
            self.userDefaults.removeObject(forKey: key.rawValue)
            
            SystemLogger.info("Направление сортировки сброшено")
        }
    }
}
