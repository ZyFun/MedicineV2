//
//  FirstAidKitsViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import UIKit

/// Протокол отображения FirstAidKitController-а
protocol FirstAidKitsDisplayLogic: AnyObject {
    /// Метод передаёт данные в модель данных
    func display(_ viewModels: [FirstAidKit]?)
}

class FirstAidKitsViewController: UIViewController {
    
    // MARK: Public properties
    /// Ссылка на presenter
    var presenter: FirstAidKitsViewControllerOutput?
    
    // MARK: Outlets
    /// Таблица с аптечками
    @IBOutlet weak var firstAidKitsTableView: UITableView!
    
    // MARK: Private properties
    /// Модель данных "Аптечка".
    /// Содержит в себе все аптечки которые были сохранены в базу.
    private var viewModels: [FirstAidKit]?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        presenter?.requestData()
    }
}
// MARK: - Конфигурирование ViewController
extension FirstAidKitsViewController {
    /// Метод инициализации VC
    func setup() {
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: Setup navigation bar
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
    
    // MARK: Setup table view
    /// Метод настройки таблицы
    func setupTableView() {
        firstAidKitsTableView.delegate = self
        firstAidKitsTableView.dataSource = self
        
        // TODO: Удалить после прекращения поддержки iOS ниже 15
        firstAidKitsTableView.tableFooterView = UIView()
        
        setupXibs()
    }
    
    /// Инициализация Xibs
    func setupXibs() {
        // Регистрируем ячейку для таблицы аптечек
        firstAidKitsTableView.register(
            UINib(
                nibName: String(describing: FirstAidKitTableViewCell.self),
                bundle: nil
            ),
            forCellReuseIdentifier: String(describing: FirstAidKitTableViewCell.self)
        )
    }
    
    // MARK: Actions
    @objc func addNewFirstAidKit() {
        showAlert()
    }
}

// MARK: - Table view data source
extension FirstAidKitsViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModels?.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FirstAidKitTableViewCell.self),
            for: indexPath
        ) as! FirstAidKitTableViewCell
        
        let firstAidKit = viewModels?[indexPath.row]
        
        let currentAmountMedicines = "1" // TODO: Извлечь количество лекарств в текущей аптечке. Посчитать количество в переданном и отфильтрованном массиве
        
        cell.accessoryType = .disclosureIndicator
        cell.configure(
            titleFirstAidKit: firstAidKit?.title,
            amountMedicines: currentAmountMedicines
        )
        
        return cell
    }
}

// MARK: - Table view delegate
extension FirstAidKitsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.routeToMedicines(by: indexPath)
    }
    
    // TODO: Использовать этот метод, когда потребуется дополнительный функционал свайпа по ячейке
    /*
    // Метод позволяет настроить пользовательские действия, при свайпе ячейки с права на лево
    // Настроено только удаление ячейки
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [unowned self] _, _, _ in
            let firstAidKit = firstAidKits[indexPath.row]
            StorageManager.shared.deleteData(firstAidKit)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
     */
    
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let firstAidKit = viewModels?[indexPath.row]
        
        let editAction = UIContextualAction(
            style: .normal,
            title: "Изменить"
        ) { [unowned self] _, _, isDone in
            showAlert(for: firstAidKit, by: indexPath)
            
            // Возвращаем значение в убегающее замыкание,
            // чтобы отпустить интерфейс при пользовательских действиях с ячейкой
            isDone(true)
        }
        
        // Настройка конпок действий
        editAction.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            // TODO: После добавления уведомлений, не забыть добавить очистку очереди (посмотреть код из аналогичного метода старой версии)
            guard let firstAidKit = viewModels?[indexPath.row] else { return }
            
            viewModels?.remove(at: indexPath.row)
            firstAidKitsTableView.deleteRows(at: [indexPath], with: .automatic)
            presenter?.deleteData(firstAidKit)
        }
    }
}

// MARK: - Логика обновления данных View
extension FirstAidKitsViewController: FirstAidKitsDisplayLogic {
    func display(_ viewModels: [FirstAidKit]?) {
        self.viewModels = viewModels
    }
}

// MARK: - Работа с alert controller для добавления новых аптечек
private extension FirstAidKitsViewController {
    /// Метод для отображения кастомного алерт контроллера добавления или редактирования аптечки
    /// - Parameters:
    ///   - entity: принимает аптечку (опционально). Заголовок алерта зависит от того была инициализирована аптечка или нет
    ///   - index: принимает IndexPath  и используется для обновления конкретной ячейки в таблице
    func showAlert(for entity: FirstAidKit? = nil, by index: IndexPath? = nil) {
        let title = entity == nil ? "Добавить аптечку" : "Изменить название"
        let alert = UIAlertController.createAlertController(with: title)
        
        alert.action(firstAidKit: entity) { [unowned self] firstAidKitName in
            if let firstAidKit = entity {
                presenter?.updateData(firstAidKit, newName: firstAidKitName)
                
                // Используется для обновления строки после изменения имени
                if let index = index {
                    firstAidKitsTableView.reloadRows(
                        at: [index],
                        with: .automatic
                    )
                }
            } else {
                presenter?.createData(firstAidKitName)
                
                // Эта логика используется для обновления данных в таблице
                // вставкой в строку, без обновления всей таблицы.
                // TODO: Но нужно отрефакторить и сделать всё по архитектуре
                if let viewModels = viewModels {
                    var count = 0
                    
                    // Ищем в обновленнном массиве, после добавления объекта,
                    // текущий индекс объекта и вставляем по этому индексу новую
                    // ячейку в таблице аптечек.
                    for addObject in viewModels {
                        if addObject.title == firstAidKitName {
                            let index = IndexPath(row: count, section: 0)
                            firstAidKitsTableView.insertRows(
                                at: [index],
                                with: .automatic
                            )
                            return
                        }
                        count += 1
                    }
                }
            }
        }
        present(alert, animated: true)
    }
}
