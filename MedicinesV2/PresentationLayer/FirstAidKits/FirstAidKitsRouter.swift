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
    
    /// Кейсы с экранами, на которые возможно сделать переход по таргету
    enum Targets {
        /// Таргет на экран с лекарствами, с передачей текущей (выбранной) аптечки.
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
            MedicinesConfigurator(
                notificationService: NotificationService(),
                firstAidKit: firstAidKit
            )
                .config(
                    view: medicinesVC,
                    navigationController: navigationController
                )
            
            // Навигация
            navigationController?.pushViewController(medicinesVC, animated: true)
        }
    }
}
