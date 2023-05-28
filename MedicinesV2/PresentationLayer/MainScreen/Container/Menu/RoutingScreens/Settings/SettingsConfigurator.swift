//
//  SettingsConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 16.05.2023.
//

import UIKit

final class SettingsConfigurator {
    let notificationSettingService: NotificationSettings
    
    init(notificationSettingService: NotificationSettings) {
        self.notificationSettingService = notificationSettingService
    }
    
    func config(
        view: UIViewController
    ) {
        guard let view = view as? SettingsViewController else { return }
        let presenter = SettingsPresenter(view: view)
        
        view.presenter = presenter
        presenter.view = view
        presenter.notificationSettingService = notificationSettingService
    }
}
