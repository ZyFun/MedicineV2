//
//  FirstAidKitsViewController.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//
// TODO: Перенести настройки лаунч скрина с прошлого проекта. Но цвета взять из примера подборки

import UIKit

/// Класс viewController-а для экрана со списком аптечек
class FirstAidKitsViewController: UITableViewController {
    
    // MARK: - Private Properties
    private var firstAidKits: [FirstAidKit] = []

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        getFirstAidKits()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        firstAidKits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstAidKit", for: indexPath)
        let firstAidKit = firstAidKits[indexPath.row]
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = firstAidKit.title
            
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = firstAidKit.title
        }

        return cell
    }
    
    // Работа с нажатием на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        createMedicinesVC()
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
        
        let firstAidKit = firstAidKits[indexPath.row]
        
        let editAction = UIContextualAction(style: .normal, title: "Изменить") { [unowned self] _, _, isDone in
            showAlert(firstAidKit: firstAidKit) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            // Возвращаем значение в убегающее замыкание, чтобы отпустить интерфейс при пользовательских действиях с ячейкой
            isDone(true)
        }
        
        // Настройка конпок действий
        editAction.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [editAction])
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
            let firstAidKit = firstAidKits[indexPath.row]
            firstAidKits.remove(at: indexPath.row)
            StorageManager.shared.deleteData(firstAidKit)
            tableView.deleteRows(at: [indexPath], with: .fade)
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

    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let medicineVC = segue.destination as? MedicinesViewController else { return }
//    }
    
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
    ///   - firstAidKit: принимает аптечку (опционально). Заголовок алерта зависит от того была инициализирована аптечка или нет
    ///   - completion: используется для вызова перезагрузки таблицы (опционально)
    func showAlert(firstAidKit: FirstAidKit? = nil, completion: (() -> Void)? = nil) {
        let title = firstAidKit == nil ? "Добавить аптечку" : "Изменить название"
        let alert = UIAlertController.createAlertController(with: title)
        
        alert.action(firstAidKit: firstAidKit) { [unowned self] firstAidKitName in
            if let firstAidKit = firstAidKit, let completion = completion {
                StorageManager.shared.editData(firstAidKit, newName: firstAidKitName)
                completion()
            } else {
                save(firstAidKitName)
            }
        }
        present(alert, animated: true)
    }
}

// MARK: - Инициализация вью Medicines
// Всё это нужно для подготовки к уходу от сторибордов и написанию интерфейса кодом.
private extension FirstAidKitsViewController {
    func createMedicinesVC() {
        // Создание ViewController
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let medicinesVC = storyboard.instantiateViewController(withIdentifier: "medicines") as? MedicinesViewController else { return }
        
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
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let firstAidKits):
                self.firstAidKits = firstAidKits
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    /// Сохранение новой аптечки
    /// - Parameter firstAidKitName: свойство принимает название добавляемой аптечки, для его дальнейшего сохранения в базу.
    func save(_ firstAidKitName: String) {
        StorageManager.shared.saveData(firstAidKitName) { firstAidKit in
            firstAidKits.append(firstAidKit)
        }
        /// Индекс строки последней ячейки в таблице
        let cellIndex = IndexPath(row: firstAidKits.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
    }
}
