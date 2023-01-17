//
//  MenuDataSourceProvider.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 13.01.2023.
//

import UIKit

protocol IMenuDataSourceProvider: UITableViewDelegate, UITableViewDataSource {
    #warning("Удалить каку после добавления роутера и презентера")
    var view: UIViewController? { get set }
}

final class MenuDataSourceProvider: NSObject, IMenuDataSourceProvider {
    
    #warning("Удалить каку после добавления роутера и презентера")
    var view: UIViewController?
    
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
            CustomLogger.error("Ячейка меню не создана")
            return UITableViewCell()
        }
        
        guard let menuModel = MenuModel(rawValue: indexPath.row) else {
            CustomLogger.error("Меню не собралось")
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
        #warning("Удалить каку после добавления роутера и презентера")
        // TODO: (#Add) Дописать логику перехода на определенный экран из меню
        // сделать презентер и роутер для этого модуля, и октрывать экран через них.
        guard let menu = MenuModel(rawValue: indexPath.row) else { return }
        
        switch menu {
        case .settings:
            CustomLogger.warning("Меню настроек в разработке")
        case .aboutApp:
            let view = AboutAppViewController()
            PresentationAssembly().aboutApp.config(view: view)
            self.view?.present(view, animated: true)
            // Добавить сворачивание меню
        }
        
    }
    
}
