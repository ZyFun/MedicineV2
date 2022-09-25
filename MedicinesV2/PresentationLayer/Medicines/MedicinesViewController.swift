//
//  MedicinesViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

/// Протокол отображения ViewCintroller-a
protocol MedicinesDisplayLogic: AnyObject {
    
}

final class MedicinesViewController: UIViewController {
    
    // MARK: - Public properties
    
    /// Ссылка на presenter
    var presenter: MedicinesViewControllerOutput?
    var dataSourceProvider: IMedicinesDataSourceProvider?
    var fetchedResultManager: IMedicinesFetchedResultsManager?
    /// Содержит в себе выбранную аптечку
    var currentFirstAidKit: DBFirstAidKit?

    // MARK: - IBOutlets
    
    /// Таблица с лекарствами
    @IBOutlet weak var medicinesTableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.updateNotificationBadge()
    }
}

// MARK: - Конфигурирование ViewController

private extension MedicinesViewController {
    
    /// Метод инициализации VC
    func setup() {
        setupNavigationBar()
        setupTableView()
        setupXibs()
    }
    
    // MARK: - Setup table view
    
    /// Метод настройки таблицы
    func setupTableView() {
        medicinesTableView?.delegate = dataSourceProvider
        medicinesTableView?.dataSource = dataSourceProvider
        
        fetchedResultManager?.tableView = medicinesTableView
        
        // TODO: (#Version) Актуально для iOS ниже 15 версии. Можно удалить после прекращения поддержки этих версий
        medicinesTableView?.tableFooterView = UIView()
        
        setupXibs()
    }
    
    /// Инициализация Xibs
    func setupXibs() {
        medicinesTableView?.register(
            UINib(
                nibName: String(describing: MedicineCell.self),
                bundle: nil
            ),
            forCellReuseIdentifier: String(describing: MedicineCell.self)
        )
    }
    
    // MARK: - Setup navigation bar
    
    /// Метод настройки Navigation Bar
    func setupNavigationBar() {
        title = currentFirstAidKit?.title
        addButtons()
    }
    
    /// Добавление кнопок в navigation bar
    func addButtons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMedicine))
        navigationItem.rightBarButtonItems = [addButton]
    }
    /// Добавление нового лекарства
    @objc func addNewMedicine() {
        presenter?.routeToMedicine(with: currentFirstAidKit, by: nil)
    }
}

// MARK: - Логика обновления данных View

extension MedicinesViewController: MedicinesDisplayLogic {
    func display(_ viewModels: [DBMedicine]) {
        
    }
}
