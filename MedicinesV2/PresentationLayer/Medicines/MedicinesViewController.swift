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
        view.backgroundColor = .systemGray6
        setupNavigationBar()
        setupTableView()
        setupPlaceholder()
    }
    
    // MARK: - Setup navigation bar
    
    /// Метод настройки Navigation Bar
    func setupNavigationBar() {
        title = currentFirstAidKit?.title
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.196842283, green: 0.4615264535, blue: 0.4103206396, alpha: 1)
        addButtons()
        addSearchController()
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
    
    func addSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Введите название или тип лекарства"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Setup table view
    
    /// Метод настройки таблицы
    func setupTableView() {
        medicinesTableView?.delegate = dataSourceProvider
        medicinesTableView?.dataSource = dataSourceProvider
        
        medicinesTableView.separatorStyle = .none
        medicinesTableView.backgroundColor = .systemGray6
        
        fetchedResultManager?.tableView = medicinesTableView
        
        registerCell()
    }
    
    /// Регистрация ячейки
    func registerCell() {
        medicinesTableView?.register(
            MedicineCell.self,
            forCellReuseIdentifier: String(describing: MedicineCell.identifier)
        )
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

// MARK: - UISearchBarDelegate

// TODO: (#Архитектура) пересмотреть код, не нарушает ли это архитектуру
extension MedicinesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let currentFirstAidKit else { return }
        let firstAidKitFilter = NSPredicate(
            format: "%K == %@", "firstAidKit", currentFirstAidKit
        )
        let medicineFilter = NSPredicate(
            format: "title CONTAINS[c] %@ OR type CONTAINS[c] %@ OR purpose CONTAINS[c] %@",
            searchText,
            searchText,
            searchText
        )
        
        fetchedResultManager?.fetchedResultsController
            .fetchRequest.predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    firstAidKitFilter,
                    medicineFilter
                ]
            )
        
        do {
            try fetchedResultManager?.fetchedResultsController.performFetch()
        } catch let error {
            SystemLogger.error(error.localizedDescription)
        }
        
        medicinesTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let currentFirstAidKit else { return }
        let firstAidKitFilter = NSPredicate(
            format: "%K == %@", "firstAidKit", currentFirstAidKit
        )
        
        fetchedResultManager?.fetchedResultsController
            .fetchRequest.predicate = firstAidKitFilter
        
        do {
            try fetchedResultManager?.fetchedResultsController.performFetch()
        } catch let error {
            SystemLogger.error(error.localizedDescription)
        }
        
        medicinesTableView.reloadData()
    }
}
