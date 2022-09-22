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
    
    /// Инжектирование зависимостей в  ``FirstAidKitsConfigurator``
    lazy var firstAidKits: FirstAidKitsConfigurator = {
        return FirstAidKitsConfigurator(coreDataService: coreDataService)
    }()
    
    lazy var medicines: MedicinesConfigurator = {
        return MedicinesConfigurator(
            notificationService: notificationService,
            coreDataService: coreDataService
        )
    }()
    
    lazy var medicine: MedicineConfigurator = {
        return MedicineConfigurator(coreDataService: coreDataService)
    }()
}
