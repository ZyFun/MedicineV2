//
//  MenuViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.01.2023.
//

import UIKit

#warning("отрефакторить весь класс")
final class MenuViewController: UIViewController {
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.196842283, green: 0.4615264535, blue: 0.4103206396, alpha: 1)
        configureTableView()
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            MenuCell.self,
            forCellReuseIdentifier: MenuCell.identifier
        )
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 90
        
        tableView.backgroundColor = #colorLiteral(red: 0.196842283, green: 0.4615264535, blue: 0.4103206396, alpha: 1)
        
        tableView.contentInset.top = 100
        tableView.isScrollEnabled = false
    }
}

extension MenuViewController: UITableViewDataSource {
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

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
