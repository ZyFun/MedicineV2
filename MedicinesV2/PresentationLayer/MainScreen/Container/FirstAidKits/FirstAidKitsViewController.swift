//
//  FirstAidKitsViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import UIKit

/// Протокол отображения ViewCintroller-a
protocol FirstAidKitsDisplayLogic: AnyObject {
    /// Метод для скрытия сплешскрина
    /// - Скрывает сплешскрин по окончанию загрузки всех данных и настройки приложения
    /// - на данный момент вызывается методом `updateAllNotifications` в интеракторе.
    func dismissSplashScreen()
    /// Метод для скрытия плейсхолдера
    /// - Скрывает его, если список аптечек не пустой
    func hidePlaceholder()
    /// Метод для отображения плейсхолдера
    /// - Показывает его, если список аптечек пустой
    func showPlaceholder()
    /// Метод для обновления лейбла о просроченных лекарствах в аптечке
    func updateExpiredMedicinesLabel()
    /// Метод для отображения кастомного алерт контроллера добавления или редактирования аптечки
    /// - Parameters:
    ///   - entity: Принимает аптечку
    ///   - index: принимает IndexPath  и используется для обновления конкретной ячейки в таблице
    /// - Метод с входящими данными редактирует выбранную аптечку.
    /// - Метод без входящих данных, создаёт новую аптечку.
    func showAlert(for entity: DBFirstAidKit?, by indexPath: IndexPath?)
}

protocol FirstAidKitsControllerDelegate: AnyObject {
    func toggleDisplayMenu()
}

final class FirstAidKitsViewController: UIViewController {
    
    // MARK: - Public properties
    
    /// Ссылка на presenter
    var presenter: FirstAidKitsViewControllerOutput?
    var splashPresenter: ISplashPresenter?
    var dataSourceProvider: IFirstAidKitsDataSourceProvider?
    var fetchedResultManager: IFirstAidKitsFetchedResultsManager?
    
    // TODO: (#Refactor) сделать презентер, для контейнера с меню, и управление через него
    weak var delegate: FirstAidKitsControllerDelegate?
    
    // MARK: - Outlets
    
    /// Таблица с аптечками
    @IBOutlet weak var firstAidKitsTableView: UITableView!
    /// Плейсхолдер
    /// - Отображается, когда в списке еще нет аптечек
    @IBOutlet weak var placeholderLabel: UILabel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splashPresenter?.present()
        
        setup()
        presenter?.updatePlaceholder()
        presenter?.updateNotificationBadge()
        presenter?.updateAllNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // FIXME: При первом входе дергает базу данных для поиска просрочки лишний раз
        // Это не нужно делать, так как изначально сразу загружаются правильные данные
        // и нужно только при обновлении лекарства
        presenter?.searchExpiredMedicines()
    }
}

// MARK: - Конфигурирование ViewController

extension FirstAidKitsViewController {
    
    /// Метод инициализации VC
    func setup() {
        view.backgroundColor = .systemGray6
        setupNavigationBar()
        setupTableView()
        setupPlaceholder()
    }
    
    // MARK: - Setup navigation bar
    
    /// Метод настройки navigation bar
    func setupNavigationBar() {
        titleSetup()
        addBarButtons()
        addSearchController()
    }
    
    /// Метод для настройки заголовка navigation bar
    func titleSetup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Аптечки"
    }
    
    /// Метод для добавления кнопок в navigation bar
    func addBarButtons() {
        let addBarButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewFirstAidKit)
        )
        addBarButton.tintColor = #colorLiteral(red: 0.196842283, green: 0.4615264535, blue: 0.4103206396, alpha: 1)
        
        let menuBarButton = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .plain,
            target: self,
            action: #selector(openMenu)
        )
        menuBarButton.tintColor = #colorLiteral(red: 0.196842283, green: 0.4615264535, blue: 0.4103206396, alpha: 1)
        
        navigationItem.rightBarButtonItem = addBarButton
        navigationItem.leftBarButtonItem = menuBarButton
    }
    
    /// Метод для открытия или закрытия меню
    @objc func openMenu() {
        delegate?.toggleDisplayMenu()
    }
    
    /// Метод для добавления новой аптечки.
    /// - Вызывает алерт контроллер, с помощью которого будет производится добавление аптечки
    @objc func addNewFirstAidKit() {
        presenter?.showAlert(for: nil, by: nil)
    }
    
    func addSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Введите название аптечки"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Setup table view
    
    /// Метод настройки таблицы
    func setupTableView() {
        firstAidKitsTableView.delegate = dataSourceProvider
        firstAidKitsTableView.dataSource = dataSourceProvider
        
        firstAidKitsTableView.separatorStyle = .none
        firstAidKitsTableView.backgroundColor = .systemGray6
        
        fetchedResultManager?.tableView = firstAidKitsTableView
        
        registerCell()
    }
    
    /// Регистрация ячейки
    func registerCell() {
        // Регистрируем ячейку для таблицы аптечек
        firstAidKitsTableView.register(
            FirstAidKitCell.self,
            forCellReuseIdentifier: FirstAidKitCell.identifier
        )
    }
    
    // MARK: - Setup placeholders
    
    func setupPlaceholder() {
        placeholderLabel.textColor = .systemGray
    }
}

// MARK: - Логика обновления данных View

extension FirstAidKitsViewController: FirstAidKitsDisplayLogic {
    
    func updateExpiredMedicinesLabel() {
        firstAidKitsTableView.reloadData()
    }
    
    func dismissSplashScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.splashPresenter?.dismiss { [weak self] in
                self?.splashPresenter = nil
            }
        }
    }
    
    func hidePlaceholder() {
        DispatchQueue.main.async {
            self.placeholderLabel.isHidden = true
        }
    }
    
    func showPlaceholder() {
        DispatchQueue.main.async {
            self.placeholderLabel.isHidden = false
        }
    }
    
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

// MARK: - UISearchBarDelegate

// TODO: (#Архитектура) пересмотреть код, не нарушает ли это архитектуру
extension FirstAidKitsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let firstAidKitFilter = NSPredicate(
            format: "title CONTAINS[c] %@", searchText
        )
        
        fetchedResultManager?.fetchedResultsController
            .fetchRequest.predicate = firstAidKitFilter
        
        do {
            try fetchedResultManager?.fetchedResultsController.performFetch()
        } catch let error {
            CustomLogger.error(error.localizedDescription)
        }
        
        firstAidKitsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchedResultManager?.fetchedResultsController
            .fetchRequest.predicate = nil
        
        do {
            try fetchedResultManager?.fetchedResultsController.performFetch()
        } catch let error {
            CustomLogger.error(error.localizedDescription)
        }
        
        firstAidKitsTableView.reloadData()
    }
}
