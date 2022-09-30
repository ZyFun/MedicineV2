//
//  PresentationAssembly.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.09.2022.
//

/// Точка входа сервисов в модули
final class PresentationAssembly {
    private let serviceAssembly = ServiceAssembly()
    
    private let notificationService: INotificationService
    private let coreDataService: ICoreDataService
    
    init() {
        notificationService = serviceAssembly.notificationService
        coreDataService = serviceAssembly.coreDataService
    }
    
    lazy var notificationMedicineManager: INotificationMedicineManager = {
        return NotificationMedicineManager(notificationService: notificationService)
    }()
    
    /// Инжектирование зависимостей в ``FirstAidKitsConfigurator``
    lazy var firstAidKits: FirstAidKitsConfigurator = {
        return FirstAidKitsConfigurator(
            notificationService: notificationService,
            coreDataService: coreDataService
        )
    }()
    
    /// Инжектирование зависимостей в ``MedicinesConfigurator``
    lazy var medicines: MedicinesConfigurator = {
        return MedicinesConfigurator(
            notificationManager: notificationMedicineManager,
            coreDataService: coreDataService
        )
    }()
    
    /// Инжектирование зависимостей в ``MedicineConfigurator``
    lazy var medicine: MedicineConfigurator = {
        return MedicineConfigurator(
            notificationManager: notificationMedicineManager,
            coreDataService: coreDataService)
    }()
}
