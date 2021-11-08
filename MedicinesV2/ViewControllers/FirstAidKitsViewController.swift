//
//  FirstAidKitsViewController.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//
// TODO: ПРодолжить смотреть обучающий урок по кордате
// TODO: Перенести настройки лаунч скрина с прошлого проекта. Но цвета взять из примера подборки

import UIKit

class FirstAidKitsViewController: UITableViewController {
    
    // TODO: Удалить это свойство после добавления базы данных
    var testFirstAidKit = ["Домашняя аптечка", "Аптечка в машине"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // Использую только в случае добавления данных на стороннем экране.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        testFirstAidKit.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstAidKit", for: indexPath)
        
        let firstAidKit = testFirstAidKit[indexPath.row]
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = firstAidKit
            
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = firstAidKit
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addNewAidKit = segue.destination as? NewFirstAidKitViewController else { return }
        addNewAidKit.newAidKit = testFirstAidKit
    }

}
