//
//  MedicineTableViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 01.12.2021.
//
// TODO: Навигейшн контроллер дублируется. Возможно это связано с тем, что нарушена архитектура. Разобраться с этим после того, как перепишу код под полноценную работу VIPER и вход будет осуществляться через AppDelegate

import UIKit

class MedicineTableViewController: UITableViewController {
    
    // TODO: Временное решение для тестирования, до момента создания всей БД.
    // MARK: Переданные данные с другого вью
    var medicineName: String = ""
    
    // MARK: IB Outlets
    @IBOutlet weak var medicineNameTextField: UITextField!
    @IBOutlet weak var medicineAmountTextField: UITextField!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    // MARK: - Table view delegate

}

// MARK: - Конфигурирование ViewController
private extension MedicineTableViewController {
    /// Метод инициализации VC
    func setup() {
        setupNavBar()
        setupTableView()
    }
    
    func setupNavBar() {
        // Возможно потребуется, когда вход в приложение будет без сториборда, если нет, удалить
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = medicineName
    }
}

// MARK: - Настройка таблицы
private extension MedicineTableViewController {
    func setupTableView() {
        tableView.allowsSelection = false
    }
}
