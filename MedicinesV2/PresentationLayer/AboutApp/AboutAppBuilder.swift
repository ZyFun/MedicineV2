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

class ModuleBuilder: Builder {
    static func createAboutAppModule() -> UIViewController {
        let model = AboutAppModel(
            description: "Приложение аптечка",
            nameDeveloper: "Данилин Дмитрий",
            version: "\(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))"
        )
        
        let view = AboutAppViewController()
        let presenter = AboutAppPresenter(view: view, info: model)
        view.presenter = presenter
        
        return view
    }
}
