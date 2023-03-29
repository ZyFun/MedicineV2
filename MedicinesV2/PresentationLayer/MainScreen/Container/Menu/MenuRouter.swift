//
//  MenuRouter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.03.2023.
//

import UIKit

/// Протокол логики роутера
protocol MenuRoutingLogic {
    /// Переход к определенному экрану по таргету
    /// - Parameter target: таргет экрана, на который будет осуществлен переход
    func routeTo(target: MenuRouter.Targets)
}

final class MenuRouter: MenuRoutingLogic {
    
    private var navigationController: UINavigationController?
    
    init(withNavigationController: UINavigationController?) {
        navigationController = withNavigationController
    }
    
    /// Таргет для перехода на другой экран
    enum Targets {
        /// Экран с информацией о приложении
        case aboutApp
    }
    
    func routeTo(target: MenuRouter.Targets) {
        switch target {
        case .aboutApp:
            // Создание ViewController
            let view = AboutAppViewController()
            
            // Конфигурация модуля для инжектирования зависимостей
            PresentationAssembly().aboutApp.config(view: view)
            
            // Навигация
            view.modalPresentationStyle = .pageSheet
            navigationController?.present(view, animated: true)
        }
    }
}
