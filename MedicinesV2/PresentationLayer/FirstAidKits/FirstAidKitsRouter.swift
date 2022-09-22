//
//  FirstAidKitsRouter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import UIKit

/// Протокол логики роутера
protocol FirstAidKitRoutingLogic {
    /// Переход к определенному экрану по таргету
    /// - Parameter target: таргет экрана, на который будет осуществлен переход
    func routeTo(target: FirstAidKitRouter.Targets)
}

final class FirstAidKitRouter: FirstAidKitRoutingLogic {
    
    private var navigationController: UINavigationController?
    
    init(withNavigationController: UINavigationController?) {
        navigationController = withNavigationController
    }
    
    /// Таргет для перехода на другой экран
    enum Targets {
        /// Экран с лекарствами, с передачей текущей (выбранной) аптечки.
        case medicines(DBFirstAidKit)
    }
    
    func routeTo(target: FirstAidKitRouter.Targets) {
        switch target {
        case .medicines(let firstAidKit):
            // Создание ViewController
            let medicinesVC = MedicinesViewController(
                nibName: String(describing: MedicinesViewController.self),
                bundle: nil
            )
            
            // Конфигурация VIPER модуля для инжектирования зависимостей
            PresentationAssembly().medicines.config(
                view: medicinesVC,
                navigationController: navigationController,
                currentFirstAidKit: firstAidKit
            )
            
            // Навигация
            navigationController?.pushViewController(medicinesVC, animated: true)
        }
    }
}
