//
//  MenuDataSourceProvider.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 13.01.2023.
//

import UIKit

protocol IMenuDataSourceProvider: UITableViewDelegate, UITableViewDataSource {
    
}

final class MenuDataSourceProvider: NSObject, IMenuDataSourceProvider {
    
}

// MARK: - Table view data source

extension MenuDataSourceProvider: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: (#Fix) брать количество ячеек из модели
        2
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
            CustomLogger.error("Нет данных в ячейке по указанному индексу")
            return UITableViewCell()
        }
        
        cell.configure(
            iconImage: menuModel.image,
            title: menuModel.description
        )
        
        return cell
    }
    
}

// MARK: - Table view delegate

extension MenuDataSourceProvider: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CustomLogger.warning("Выбрана ячейка \(indexPath.row.description)" )
    }
    
}
