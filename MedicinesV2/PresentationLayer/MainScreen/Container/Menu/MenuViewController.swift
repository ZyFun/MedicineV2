//
//  MenuViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.01.2023.
//

import UIKit

#warning("Вынести data source и delegate в отдельный класс")
final class MenuViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = #colorLiteral(red: 0.196842283, green: 0.4615264535, blue: 0.4103206396, alpha: 1)
        tableView.separatorStyle = .none
        tableView.rowHeight = 90
        tableView.contentInset.top = 100
        tableView.isScrollEnabled = false
        return tableView
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
}

// MARK: - Конфигурирование ViewController

private extension MenuViewController {
    
    /// Метод инициализации VC
    func setup() {
        view.addSubview(menuTableView)
        view.backgroundColor = #colorLiteral(red: 0.196842283, green: 0.4615264535, blue: 0.4103206396, alpha: 1)
        setupTableView()
    }
    
    // MARK: - Setup table view
    
    /// Метод настройки таблицы
    func setupTableView() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        menuTableView.frame = view.bounds
        
        registerCell()
    }
    
    /// Регистрация ячейки
    func registerCell() {
        // Регистрируем ячейку для таблицы меню
        menuTableView.register(
            MenuCell.self,
            forCellReuseIdentifier: MenuCell.identifier
        )
    }
    
}

// MARK: - Table view data source

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

// MARK: - Table view delegate

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CustomLogger.warning("Выбрана ячейка \(indexPath.row.description)" )
    }
    
}
