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
    private let sortingService: SortableSettings
    private let notificationSettingService: NotificationSettings
    
    init() {
        notificationService = serviceAssembly.notificationService
        coreDataService = serviceAssembly.coreDataService
        sortingService = serviceAssembly.sortingService
        notificationSettingService = serviceAssembly.notificationSettingService
    }
    
    /// Инжектирование зависимостей в ``NotificationMedicineManager``
    lazy var notificationMedicineManager: INotificationMedicineManager = {
        return NotificationMedicineManager(
            notificationService: notificationService,
            notificationSettingService: notificationSettingService,
            logger: serviceAssembly.logger
        )
    }()
    
    /// Инжектирование зависимостей в ``FirstAidKitsConfigurator``
    lazy var firstAidKits: FirstAidKitsConfigurator = {
        return FirstAidKitsConfigurator(
            notificationManager: notificationMedicineManager,
            coreDataService: coreDataService,
            splashPresenter: SplashPresenter(),
            logger: serviceAssembly.logger
        )
    }()
    
    /// Инжектирование зависимостей в ``MenuConfigurator``
    lazy var menu: MenuConfigurator = {
        return MenuConfigurator(logger: serviceAssembly.logger)
    }()
    
    /// Инжектирование зависимостей в ``AboutAppConfigurator``
    lazy var aboutApp: AboutAppConfigurator = {
        return AboutAppConfigurator(logger: serviceAssembly.logger)
    }()
    
    /// Инжектирование зависимостей в ``SettingsConfigurator``
    lazy var settings: SettingsConfigurator = {
        return SettingsConfigurator(
            notificationSettingService: notificationSettingService,
            sortingSettingService: sortingService,
            logger: serviceAssembly.logger
        )
    }()
    
    /// Инжектирование зависимостей в ``MedicinesConfigurator``
    lazy var medicines: MedicinesConfigurator = {
        return MedicinesConfigurator(
            notificationManager: notificationMedicineManager,
            coreDataService: coreDataService,
            sortingService: sortingService,
            logger: serviceAssembly.logger
        )
    }()
    
    /// Инжектирование зависимостей в ``MedicineConfigurator``
    lazy var medicine: MedicineConfigurator = {
        return MedicineConfigurator(
            notificationManager: notificationMedicineManager,
            coreDataService: coreDataService,
            logger: serviceAssembly.logger
        )
    }()
}
