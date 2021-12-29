//
//  FirstAidKitsRouter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import UIKit

protocol FirstAidKitRoutingLogic {
    func routeTo(target: FirstAidKitRouter.Targets)
}

final class FirstAidKitRouter: FirstAidKitRoutingLogic {
    
    private var navigationController: UINavigationController?
    
    init(withNavigationController: UINavigationController?) {
        navigationController = withNavigationController
    }
    
    enum Targets {
        case medicines(FirstAidKit)
    }
    
    func routeTo(target: FirstAidKitRouter.Targets) {
        switch target {
        case .medicines(let firstAidKit):
            // Создание ViewController
            let medicinesVC = MedicinesViewController(
                nibName: String(describing: MedicinesViewController.self),
                bundle: nil
            )
            
            // Конфигурирация VIPER модуля для инжектирования зависимостей
            MedicinesConfigurator(firstAidKit: firstAidKit)
                .config(
                    view: medicinesVC,
                    navigationController: navigationController
                )
            
            // Навигация
            navigationController?.pushViewController(medicinesVC, animated: true)
        }
    }
}
