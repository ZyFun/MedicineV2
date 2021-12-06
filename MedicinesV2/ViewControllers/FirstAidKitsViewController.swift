//
//  FirstAidKitsViewController.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//
// TODO: Перенести настройки лаунч скрина с прошлого проекта. Но цвета взять из примера подборки

import UIKit
import CoreData

/// Класс viewController-а для экрана со списком аптечек
class FirstAidKitsViewController: UITableViewController {
    
    // MARK: - Private Properties
    private var firstAidKit: FirstAidKit?
    // TODO: Как я понимаю, это действие должен будет выполнять интерактор, передавая уже нужную модель данных дальше
    // Имя и ключ, лучше всего будет передавать через перечисления, чтобы не ошибиться. Если имя это еще спорно, то ключ точно, так как в будущем ключ будет зависеть от выбора пользователя
    private var fetchedResultsController = StorageManager.shared.fetchedResultsController(entityName: "FirstAidKit", keyForSort: "title")

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        getFirstAidKits()
    }
    
    // MARK: - Table view delegate
    // Работа с нажатием на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    // Редактирование названия
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
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

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            // возвращаем количество объектов в текущей секции. На данном этапе разработки есть всего одна секция, поэтому все объекты будут находиться в одной единственной секции
            // TODO: Изучить работу с секциями, с помощью fetchedResultsController
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstAidKit", for: indexPath)
        
        let firstAidKit = fetchedResultsController.object(at: indexPath) as! FirstAidKit
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = firstAidKit.title
            
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = firstAidKit.title
        }

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Удаление аптечки
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: После добавления уведомлений, не забыть добавить очистку очереди (посмотреть код из аналогичного метода старой версии)
            let firstAidKit = fetchedResultsController.object(at: indexPath) as! FirstAidKit
            StorageManager.shared.deleteObject(firstAidKit)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - IBActions
    @IBAction func addNewFirstAidKit() {
        showAlert()
    }

}

// MARK: - Настройки таблицы
private extension FirstAidKitsViewController {
    func setupTableView() {
        // MARK: Актуально для iOS ниже 15 версии. Можно удалить после прекращения поддержки этих версий
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Работа с alert controller для добавления новых аптечек
private extension FirstAidKitsViewController {
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
private extension FirstAidKitsViewController {
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

// MARK: - Работа с базой данных
private extension FirstAidKitsViewController {
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

// TODO: Скорее всего, эта штука должна быть в презентере
// MARK: - Fetched Results Controller Delegate
extension FirstAidKitsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let firstAidKit = fetchedResultsController.object(at: indexPath) as! FirstAidKit
                let cell = tableView.cellForRow(at: indexPath)
                
                if #available(iOS 14.0, *) {
                    var content = cell?.defaultContentConfiguration()
                    content?.text = firstAidKit.title
                } else {
                    cell?.textLabel?.text = firstAidKit.title
                }
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
            }
        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
