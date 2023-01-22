//
//  AboutAppConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 16.01.2023.
//

import UIKit

/// Конфигурация MVP модуля
final class AboutAppConfigurator {
    func config(
        view: UIViewController
    ) {
        let infoModel = AboutAppInfoModel(
            version: "Версия: \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))",
            developer: "Разработчик: Дмитрий Данилин",
            discordUrl: nil,
            vkUrl: "https://vk.com/public218412067",
            tgUrl: "https://t.me/+8zc4QsHHac03ZGYy"
        )
        
        guard let view = view as? AboutAppViewController else { return }
        let presenter = AboutAppPresenter(view: view, infoModel: infoModel)
        
        view.presenter = presenter
        presenter.view = view
    }
}
