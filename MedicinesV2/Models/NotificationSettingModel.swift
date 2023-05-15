//
//  NotificationSettingModel.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 15.05.2023.
//

import Foundation
import DTLogger

/// Модель настроек уведомления для хранения в UserDefaults
struct NotificationSettingModel: Codable {
    let hourNotifiable: Int
    let isRepeat: Bool
}

extension NotificationSettingModel {
    /// Метод для кодирования модели в Data, для возможности сохранения в UserDefaults
    /// - Returns: возвращает модель в виде Data
    /// - Может выбросить ошибку, если с кодированием что-то пошло не так.
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            SystemLogger.error("Не удалось кодировать настройки уведомлений")
            throw error
        }
    }
    
    /// Метод для декодирования Data в ``NotificationSettingModel``
    /// - Parameter data: принимает закодированную модель ``NotificationSettingModel``
    /// - Returns: Возвращает декодированную модель ``NotificationSettingModel``
    /// - Может выбросить ошибку, если с декодированием что-то пошло не так.
    static func decode(from data: Data) throws -> NotificationSettingModel {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(NotificationSettingModel.self, from: data)
        } catch {
            SystemLogger.error("Не удалось декодировать настройки уведомлений")
            throw error
        }
    }
}
