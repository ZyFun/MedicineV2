//
//  AboutAppBuilder.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 16.01.2023.
//

import UIKit

protocol Builder {
    static func createAboutAppModule() -> UIViewController
}

final class ModuleBuilder: Builder {
    static func createAboutAppModule() -> UIViewController {
        let infoModel = AboutAppInfoModel(
            version: "Версия: \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))",
            developer: "Разработчик: Дмитрий Данилин",
            discordUrl: nil,
            vkUrl: nil,
            tgUrl: nil,
            frameworks: nil
        )
        
        let view = AboutAppViewController()
        let presenter = AboutAppPresenter(view: view, infoModel: infoModel)
        view.presenter = presenter
        
        return view
    }
}
