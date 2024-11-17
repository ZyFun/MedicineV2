//
//  NotificationSettingCellModel.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.05.2023.
//

import Foundation

struct NotificationSettingCellModel {
    let settingName: String
    var buttonName: TimeNotification?
    var isRepeat: Bool?
    
    /// Перечесление с временем, когда будут приходить уведомления
    enum TimeNotification {
        case morning
        case day
        case evening
        
        var description: String {
            switch self {
            case .morning:
				return String(localized: "Утром")
            case .day:
                return String(localized: "Днём")
            case .evening:
                return String(localized: "Вечером")
            }
        }
        
        var value: Int {
            switch self {
            case .morning:
                return 9
            case .day:
                return 14
            case .evening:
                return 20
            }
        }
    }
}
