//
//  FirstAidKitsViewController.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//
// TODO: Продолжить смотреть обучающий урок по кордате
// TODO: Перенести настройки лаунч скрина с прошлого проекта. Но цвета взять из примера подборки

import UIKit

class FirstAidKitsViewController: UITableViewController {
    
    private var firstAidKits: [FirstAidKit] = []

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        getFirstAidKits()
        
        // MARK: Актуально для iOS ниже 15 версии. Можно удалить после прекращения поддержки этих версий
        tableView.tableFooterView = UIView()
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
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

//    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let addNewAidKit = segue.destination as? NewFirstAidKitViewController else { return }
//        addNewAidKit.newAidKit = firstAidKits
//    }
    
    // MARK: - IBActions
    @IBAction func addNewFirstAidKit() {
        showAlert(title: "Добавить аптечку",
                  message: "Введите название или расположение новой аптечки")
    }

}

// MARK: - Работа с базой данных
private extension FirstAidKitsViewController {
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

// MARK: - Работа с alert controller для добавления новых аптечек
private extension FirstAidKitsViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] _ in
            guard let firstAidKit = alert.textFields?.first?.text,
                  !firstAidKit.isEmpty else { return }
            save(firstAidKit)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "Название новой аптечки"
        }
        
        present(alert, animated: true)
    }
}
