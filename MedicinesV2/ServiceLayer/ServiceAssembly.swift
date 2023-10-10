//
//  ServiceAssembly.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.09.2022.
//

import DTLogger

/// Точка инициализации сервисов
final class ServiceAssembly {
    
    lazy var logger: DTLogger = {
        return DTLogger.shared
    }()
    
    lazy var notificationService: INotificationService = {
        return NotificationService.shared
    }()
    
    lazy var coreDataService: ICoreDataService = {
        return CoreDataService.shared
    }()
    
    lazy var sortingService: SortableSettings = {
        return SettingsService(logger: logger)
    }()
    
    lazy var notificationSettingService: NotificationSettings = {
        return SettingsService(logger: logger)
    }()
}
