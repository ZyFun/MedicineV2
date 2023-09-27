//
//  AboutAppConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 16.01.2023.
//

import UIKit
import DTLogger

/// Конфигурация MVP модуля
final class AboutAppConfigurator {
    private let logger: DTLogger
    
    init(logger: DTLogger) {
        self.logger = logger
    }
    
    func config(
        view: UIViewController
    ) {
        let infoModel = AboutAppInfoModel(
            version: "Версия: \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))",
            developer: "Разработчик: Дмитрий Данилин",
            discordUrl: nil,
            vkUrl: URLProvider.fetchSocialMediaUrl(with: .vk),
            tgUrl: URLProvider.fetchSocialMediaUrl(with: .telegram)
        )
        
        guard let view = view as? AboutAppViewController else { return }
        let presenter = AboutAppPresenter(view: view, infoModel: infoModel)
        
        view.presenter = presenter
        presenter.view = view
        presenter.logger = logger
    }
}
