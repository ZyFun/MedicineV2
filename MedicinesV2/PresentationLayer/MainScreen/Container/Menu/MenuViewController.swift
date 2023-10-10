//
//  MenuViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.01.2023.
//

import UIKit

/// Протокол отображения данных ViewCintroller-a
protocol MenuView: AnyObject {
    
}

final class MenuViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: MenuPresenter?
    var dataSourceProvider: IMenuDataSourceProvider?
    
    // MARK: - Private Properties
    
    private var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Colors.darkCyan
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
        view.backgroundColor = Colors.darkCyan
        setupTableView()
    }
    
    // MARK: - Setup table view
    
    /// Метод настройки таблицы
    func setupTableView() {
        menuTableView.delegate = dataSourceProvider
        menuTableView.dataSource = dataSourceProvider
        
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

// MARK: - Логика обновления данных View

extension MenuViewController: MenuView {
    
}
