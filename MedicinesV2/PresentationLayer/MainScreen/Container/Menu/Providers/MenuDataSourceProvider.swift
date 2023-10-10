//
//  MenuDataSourceProvider.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 13.01.2023.
//

import UIKit
import DTLogger

protocol IMenuDataSourceProvider: UITableViewDelegate, UITableViewDataSource {
    
}

final class MenuDataSourceProvider: NSObject, IMenuDataSourceProvider {
    // MARK: - Private properties
    
    private var presenter: MenuPresenter
    
    // MARK: - Dependencies
    
    private let logger: DTLogger
    
    // MARK: - Initializer
    
    init(
        presenter: MenuPresenter,
        logger: DTLogger
    ) {
        self.presenter = presenter
        self.logger = logger
    }
}

// MARK: - Table view data source

extension MenuDataSourceProvider: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MenuModel.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MenuCell.self),
            for: indexPath
        ) as? MenuCell else {
            logger.log(.error, "Ячейка меню не создана")
            return UITableViewCell()
        }
        
        guard let menuModel = MenuModel(rawValue: indexPath.row) else {
            logger.log(.error, "Меню не собралось")
            return UITableViewCell()
        }
        
        cell.configure(
            iconImage: menuModel.iconImage,
            title: menuModel.title
        )
        
        return cell
    }
    
}

// MARK: - Table view delegate

extension MenuDataSourceProvider: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menu = MenuModel(rawValue: indexPath.row) else { return }
        
        switch menu {
        case .settings:
            presenter.presentSettingsScreen()
        case .aboutApp:
            presenter.presentAboutAppScreen()
        }
        
    }
    
}
