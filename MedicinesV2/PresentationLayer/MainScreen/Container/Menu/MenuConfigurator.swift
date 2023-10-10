//
//  MenuConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.03.2023.
//

import UIKit
import DTLogger

/// Конфигурация MVP модуля
final class MenuConfigurator {
    // MARK: - Dependencies
    
    private let logger: DTLogger
    
    // MARK: - Initializer
    
    init(
        logger: DTLogger
    ) {
        self.logger = logger
    }
    
    // MARK: - Public methods
    
    func config(
        view: UIViewController,
        navigationController: UINavigationController
    ) {
        
        guard let view = view as? MenuViewController else { return }
        let presenter = MenuPresenter(view: view)
        let router = MenuRouter(withNavigationController: navigationController)
        let dataSourceProvider: IMenuDataSourceProvider = MenuDataSourceProvider(
            presenter: presenter,
            logger: logger
        )
        
        view.presenter = presenter
        view.dataSourceProvider = dataSourceProvider
        presenter.router = router
    }
}
