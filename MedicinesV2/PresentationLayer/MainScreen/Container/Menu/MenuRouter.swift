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
        /// Экран настроек
        case settings
    }
    
    func routeTo(target: MenuRouter.Targets) {
        switch target {
        case .aboutApp:
            // Создание ViewController
            let view = AboutAppViewController()
            if let sheet = view.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = Constants.CornerRadius.mainView
            }
            
            // Конфигурация модуля для инжектирования зависимостей
            PresentationAssembly().aboutApp.config(view: view)
            
            // Навигация
            navigationController?.present(view, animated: true)
        case .settings:
            // Создание ViewController
            let view = SettingsViewController()
            
            // Конфигурация модуля для инжектирования зависимостей
            PresentationAssembly().settings.config(view: view)
            
            // Навигация
            // Именно этот метод используется для того, чтобы сработал метод
            // жизненного цикла и произошло обновление всех уведомлений с уже новыми настройками
            // FIXME: По хорошему, нужен отдельный менеджер, который будет заниматься обновлением уведомлений
            // и получать доступ к базе лекарств чтобы перезаписать прошлые уведомления
            // Заменить на открытие экрана с .pageSheet
            view.modalPresentationStyle = .fullScreen
            navigationController?.present(view, animated: true)
        }
    }
}
