//
//  SettingsConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 16.05.2023.
//

import UIKit
import DTLogger

final class SettingsConfigurator {
    // MARK: - Dependencies
    
    private let notificationSettingService: NotificationSettings
    private let sortingSettingService: SortableSettings
	private let coreDataService: ICoreDataService
	private let notificationManager: INotificationMedicineManager
    private let logger: DTLogger
    
    // MARK: - Initializer
    
	init(
		notificationSettingService: NotificationSettings,
		sortingSettingService: SortableSettings,
		coreDataService: ICoreDataService,
		notificationManager: INotificationMedicineManager,
		logger: DTLogger
	) {
		self.notificationSettingService = notificationSettingService
		self.sortingSettingService = sortingSettingService
		self.coreDataService = coreDataService
		self.notificationManager = notificationManager
		self.logger = logger
	}
    
    // MARK: - Public properties
    
    func config(
        view: UIViewController
    ) {
        guard let view = view as? SettingsViewController else { return }
        let presenter = SettingsPresenter(view: view)
        
        view.presenter = presenter
        view.logger = logger
        presenter.view = view
        presenter.notificationSettingService = notificationSettingService
        presenter.sortingSettingService = sortingSettingService
		presenter.coreDataService = coreDataService
		presenter.notificationManager = notificationManager
        presenter.logger = logger
    }
}
