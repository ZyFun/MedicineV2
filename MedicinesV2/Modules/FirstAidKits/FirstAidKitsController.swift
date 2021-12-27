//
//  FirstAidKitsController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import UIKit
import CoreData

/// Протокол отображения FirstAidKitController-а
protocol FirstAidKitsDisplayLogic: AnyObject {
    /// Метод передаёт данные в модель данных
    func display(_ viewModels: FirstAidKit?)
}

class FirstAidKitsController: UIViewController {
    
    // MARK: Public properties
    /// Ссылка на presenter
    var presenter: FirstAidKitsViewControllerOutput?
    
    // MARK: Outlets
    @IBOutlet weak var firstAidKitsTableView: UITableView!
    
    // MARK: Private properties
    private var viewModel: FirstAidKit?
    
    // MARK: - Старый способ, переписать.
    private var firstAidKit: FirstAidKit?
    // TODO: Как я понимаю, это действие должен будет выполнять интерактор, передавая уже нужную модель данных дальше
    // Имя и ключ, лучше всего будет передавать через перечисления, чтобы не ошибиться. Если имя это еще спорно, то ключ точно, так как в будущем ключ будет зависеть от выбора пользователя
    private var fetchedResultsController = StorageManager.shared.fetchedResultsController(entityName: "FirstAidKit", keyForSort: "title")

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}
// MARK: - Конфигурирование ViewController
extension FirstAidKitsController {
    /// Метод инициализации VC
    func setup() {
        setupNavigationBar()
        setupTableView()
        setupXib()
        getFirstAidKits()
    }
    
    /// Метод настройки Navigation Bar
    func setupNavigationBar() {
        // TODO: Произвести настройку
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Аптечки"
        
        addBarButton()
    }
    
    /// Метод настройки таблицы
    func setupTableView() {
        firstAidKitsTableView.delegate = self
        firstAidKitsTableView.dataSource = self
        
        // MARK: Актуально для iOS ниже 15 версии. Можно удалить после прекращения поддержки этих версий
        firstAidKitsTableView.tableFooterView = UIView()
    }
    
    /// Инициализация Xibs
    func setupXib() {
        // Регистрируем ячейку для таблицы аптечек
        firstAidKitsTableView.register(
            UINib(
                nibName: String(describing: FirstAidKitTableViewCell.self),
                bundle: nil
            ),
            forCellReuseIdentifier: String(describing: FirstAidKitTableViewCell.self)
        )
    }
    
    func addBarButton() {
        let add = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewFirstAidKit)
        )
        
        navigationItem.rightBarButtonItem = add
    }
    
    // MARK: Actions
    @objc func addNewFirstAidKit() {
        showAlert()
    }
}

// MARK: - Table view data source
extension FirstAidKitsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            // возвращаем количество объектов в текущей секции. На данном этапе разработки есть всего одна секция, поэтому все объекты будут находиться в одной единственной секции
            // TODO: Изучить работу с секциями, с помощью fetchedResultsController
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FirstAidKitTableViewCell.self), for: indexPath) as! FirstAidKitTableViewCell
        
        let firstAidKit = fetchedResultsController.object(at: indexPath) as! FirstAidKit
        
        cell.accessoryType = .disclosureIndicator
        cell.configure(
            titleFirstAidKit: firstAidKit.title,
            amountMedicines: "1" // TODO: Извлечь количество лекарств в текущей аптечке.
        )
        
        return cell
    }
}

// MARK: - Table view delegate
extension FirstAidKitsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        createMedicinesVC(with: indexPath)
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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let firstAidKit = fetchedResultsController.object(at: indexPath) as! FirstAidKit
        
        let editAction = UIContextualAction(style: .normal, title: "Изменить") { [unowned self] _, _, isDone in
            showAlert(for: firstAidKit)
            
            // Возвращаем значение в убегающее замыкание, чтобы отпустить интерфейс при пользовательских действиях с ячейкой
            isDone(true)
        }
        
        // Настройка конпок действий
        editAction.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: После добавления уведомлений, не забыть добавить очистку очереди (посмотреть код из аналогичного метода старой версии)
            let firstAidKit = fetchedResultsController.object(at: indexPath) as! FirstAidKit
            StorageManager.shared.deleteObject(firstAidKit)
        }
    }
}

// MARK: - Логика обновления данных View
extension FirstAidKitsController: FirstAidKitsDisplayLogic {
    func display(_ viewModels: FirstAidKit?) {
        viewModel = viewModels
    }
}

// MARK: - Работа с alert controller для добавления новых аптечек
private extension FirstAidKitsController {
    /// Метод для отображения кастомного алерт контроллера добавления или редактирования аптечки
    /// - Parameters:
    ///   - entity: принимает аптечку (опционально). Заголовок алерта зависит от того была инициализирована аптечка или нет
    func showAlert(for entity: FirstAidKit? = nil) {
        let title = entity == nil ? "Добавить аптечку" : "Изменить название"
        let alert = UIAlertController.createAlertController(with: title)
        
        alert.action(firstAidKit: entity) { [unowned self] firstAidKitName in
            if let firstAidKit = entity {
                firstAidKit.title = firstAidKitName
                StorageManager.shared.saveContext()
            } else {
                firstAidKit = FirstAidKit()
                firstAidKit?.title = firstAidKitName
                StorageManager.shared.saveContext()
            }
        }
        present(alert, animated: true)
    }
}

// MARK: - Инициализация вью Medicines
// Всё это нужно для подготовки к уходу от сторибордов и написанию интерфейса кодом.
private extension FirstAidKitsController {
    func createMedicinesVC(with indexPath: IndexPath) {
        // Создание ViewController
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let medicinesVC = storyboard.instantiateViewController(withIdentifier: "medicines") as? MedicinesViewController else { return }
        
        // TODO: Эта передача данных возможно нарушает архитектуру VIPER, подумать как это можно исправить. Скорее всего это должно быть в конфигураторе
        let firstAidKits = fetchedResultsController.object(at: indexPath) as! FirstAidKit
        medicinesVC.currentFirstAidKit = firstAidKits
        
        // Конфигурирация VIPER модуля для инжектирования зависимостей
        MedicinesConfigurator().config(view: medicinesVC, navigationController: navigationController)
        
        // Навигация
        navigationController?.pushViewController(medicinesVC, animated: true)
    }
}

// TODO: Скорее всего, эта штука должна быть в презентере
// MARK: - Fetched Results Controller Delegate
extension FirstAidKitsController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        firstAidKitsTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                firstAidKitsTableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                firstAidKitsTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                firstAidKitsTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                firstAidKitsTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let firstAidKit = fetchedResultsController.object(at: indexPath) as! FirstAidKit
                let cell = firstAidKitsTableView.cellForRow(at: indexPath)
                
                if #available(iOS 14.0, *) {
                    var content = cell?.defaultContentConfiguration()
                    content?.text = firstAidKit.title
                } else {
                    cell?.textLabel?.text = firstAidKit.title
                }
                
                firstAidKitsTableView.reloadRows(at: [indexPath], with: .automatic)
                
            }
        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        firstAidKitsTableView.endUpdates()
    }
}


// MARK: - Работа с базой данных
private extension FirstAidKitsController {
    /// Метод для загрузки данных из базы данных в оперативную память
    func getFirstAidKits() {
        fetchedResultsController.delegate = self
        // TODO: Как я понимаю, это действие должен будет выполнять интерактор, передавая уже нужную модель данных дальше
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
}
