//
//  MenuViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.01.2023.
//

import UIKit

final class MenuViewController: UIViewController {
    
    // MARK: - Public properties
    
    // TODO: (#Refactor) инициализация должна быть в конфигураторе
    var dataSourceProvider: IMenuDataSourceProvider = MenuDataSourceProvider()
    
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
        menuTableView.delegate = dataSourceProvider
        menuTableView.dataSource = dataSourceProvider
        
        #warning("Удалить каку после добавления роутера и презентера")
        dataSourceProvider.view = self
        
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
