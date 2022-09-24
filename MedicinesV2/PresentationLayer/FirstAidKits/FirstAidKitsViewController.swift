//
//  FirstAidKitsViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import UIKit

/// Протокол отображения ViewCintroller-a
protocol FirstAidKitsDisplayLogic: AnyObject {
    /// Метод для отображения кастомного алерт контроллера добавления или редактирования аптечки
    /// - Parameters:
    ///   - entity: Принимает аптечку
    ///   - index: принимает IndexPath  и используется для обновления конкретной ячейки в таблице
    /// - Метод с входящими данными редактирует выбранную аптечку.
    /// - Метод без входящих данных, создаёт новую аптечку.
    func showAlert(for entity: DBFirstAidKit?, by indexPath: IndexPath?)
}

final class FirstAidKitsViewController: UIViewController {
    
    // MARK: - Public properties
    
    /// Ссылка на presenter
    var presenter: FirstAidKitsViewControllerOutput?
    var dataSourceProvider: IFirstAidKitsDataSourceProvider?
    var fetchedResultManager: IFirstAidKitsFetchedResultsManager?
    
    // MARK: - Outlets
    
    /// Таблица с аптечками
    @IBOutlet weak var firstAidKitsTableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

// MARK: - Конфигурирование ViewController

extension FirstAidKitsViewController {
    
    /// Метод инициализации VC
    func setup() {
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Setup navigation bar
    
    /// Метод настройки navigation bar
    func setupNavigationBar() {
        titleSetup()
        addBarButtons()
    }
    
    /// Метод для настройки заголовка navigation bar
    func titleSetup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Аптечки"
    }
    
    /// Метод для добавления кнопок в navigation bar
    func addBarButtons() {
        let add = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewFirstAidKit)
        )
        
        // Тут будет несколько кнопок до появления отдельного меню настроек
        navigationItem.rightBarButtonItems = [add]
    }
    
    /// Метод для добавления новой аптечки.
    /// - Вызывает алерт контроллер, с помощью которого будет производится добавление аптечки
    @objc func addNewFirstAidKit() {
        presenter?.showAlert(for: nil, by: nil)
    }
    
    // MARK: - Setup table view
    
    /// Метод настройки таблицы
    func setupTableView() {
        firstAidKitsTableView.delegate = dataSourceProvider
        firstAidKitsTableView.dataSource = dataSourceProvider
        fetchedResultManager?.tableView = firstAidKitsTableView
        
        // TODO: (#Version) Удалить после прекращения поддержки iOS ниже 15
        // нужно для скрытия пустых разделителей для более ранних версий
        firstAidKitsTableView.tableFooterView = UIView()
        
        setupXibs()
    }
    
    /// Инициализация Xibs
    func setupXibs() {
        // Регистрируем ячейку для таблицы аптечек
        firstAidKitsTableView.register(
            UINib(
                nibName: String(describing: FirstAidKitCell.self),
                bundle: nil
            ),
            forCellReuseIdentifier: String(describing: FirstAidKitCell.self)
        )
    }
}

// MARK: - Логика обновления данных View

extension FirstAidKitsViewController: FirstAidKitsDisplayLogic {
    
    func showAlert(for entity: DBFirstAidKit? = nil, by indexPath: IndexPath? = nil) {
        let title = entity == nil ? "Добавить аптечку" : "Изменить название"
        let alert = UIAlertController.createAlertController(with: title)
        
        alert.action(firstAidKit: entity) { [unowned self] firstAidKitName in
            if let firstAidKit = entity {
                presenter?.updateData(firstAidKit, newName: firstAidKitName)
                
                // Используется для плавного обновления строки после изменения имени
                // в fetchResultsController обновление происходит резко
                if let indexPath = indexPath {
                    firstAidKitsTableView.reloadRows(
                        at: [indexPath],
                        with: .automatic
                    )
                }
            } else {
                presenter?.createData(firstAidKitName)
            }
        }
        present(alert, animated: true)
    }
}
