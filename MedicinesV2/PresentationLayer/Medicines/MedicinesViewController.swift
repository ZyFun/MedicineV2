//
//  MedicinesViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

/// Протокол отображения ViewCintroller-a
protocol MedicinesDisplayLogic: AnyObject {
    /// Метод для скрытия плейсхолдера
    /// - Скрывает его, если список лекарств не пустой
    func hidePlaceholder()
    /// Метод для отображения плейсхолдера
    /// - Показывает его, если список лекарств пустой
    func showPlaceholder()
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
    /// Плейсхолдер
    /// - Отображается, когда в списке еще нет аптечек
    @IBOutlet weak var placeholderLabel: UILabel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        presenter?.updatePlaceholder(for: currentFirstAidKit)
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
        setupPlaceholder()
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
        presenter?.updatePlaceholder()
    }
    
    // MARK: - Setup placeholders
    
    func setupPlaceholder() {
        placeholderLabel.textColor = .systemGray
    }
}

// MARK: - Логика обновления данных View

extension MedicinesViewController: MedicinesDisplayLogic {
    func display(_ viewModels: [DBMedicine]) {
        
    }
    
    func hidePlaceholder() {
        DispatchQueue.main.async {
            if !self.placeholderLabel.isHidden {
                self.placeholderLabel.isHidden = true
            }
        }
    }
    
    func showPlaceholder() {
        DispatchQueue.main.async {
            if self.placeholderLabel.isHidden {
                self.placeholderLabel.isHidden = false
            }
        }
    }
}
