//
//  MedicineTableViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 01.12.2021.
//
// TODO: Навигейшн контроллер дублируется. Возможно это связано с тем, что нарушена архитектура. Разобраться с этим после того, как перепишу код под полноценную работу VIPER и вход будет осуществляться через AppDelegate

import UIKit

class MedicineTableViewController: UITableViewController {
    
    var medicine: Medicine?
    var currentFirstAidKit: FirstAidKit?
    
    // MARK: IB Outlets
    @IBOutlet weak var medicineNameTextField: UITextField!
    @IBOutlet weak var medicineAmountTextField: UITextField!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

}

// MARK: - Table view data source

// MARK: - Table view delegate

// MARK: - Инициализация ViewController
private extension MedicineTableViewController {
    /// Метод инициализации VC
    func setup() {
        setupNavigationBar()
        setupTableView()
        loadMedicine()
    }
    
    /// Настройка navigation bar
    func setupNavigationBar() {
        // Возможно потребуется, когда вход в приложение будет без сториборда, если нет, удалить
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = medicine?.title ?? "Новое лекарство"
        addButtons()
    }
    
    /// Настройка внешнего вида таблицы
    func setupTableView() {
        tableView.allowsSelection = false
    }
    
    /// Добавление кнопок в navigation bar
    func addButtons() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    /// Загрузка лекарства из базы
    func loadMedicine() {
        if let medicine = medicine {
            medicineNameTextField.text = medicine.title
            medicineAmountTextField.text = String(medicine.number)
        }
    }
    
    // MARK: Actions
    /// Кнопка сохранения
    @objc func saveButtonPressed() {
        if saveMedicine() {
            StorageManager.shared.saveContext()
            navigationController?.popViewController(animated: true)
        }
    }
    
    /// Метод для сохранения всех свойств лекарства
    func saveMedicine() -> Bool {
        // Извлекаем принудительно, так как в данном случае при пустом поле падения не будет
        // Проверяем на пустые поля
        if medicineNameTextField.text!.isEmpty {
            showAlert()
            return false
        }
        
        // Если лекарства нет в базе, создаём новое и далее присваиваем свойства его параметрам
        if medicine == nil {
            medicine = Medicine()
        }
        
        // Создание связи лекарства к аптечке (это работает, осталось только понять как отфильтовать предикатом)
        if let currentFirstAidKit = currentFirstAidKit {
            medicine?.firstAidKit = currentFirstAidKit
        }
        
        // Если лекарство есть в базе, меняем его параметры
        if let medicine = medicine {
            medicine.title = medicineNameTextField.text
            medicine.number = Float(medicineAmountTextField.text!) ?? 0
        }
        
        return true
    }
}

// MARK: Alert Controller
private extension MedicineTableViewController {
    /// Отображение алерта с ошибкой, при проверки полей на отсутствие значения
    func showAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Поле с названием лекарства не должно быть путсым",
            preferredStyle: .alert
        )
        
        let actionOk = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(actionOk)
        
        present(alert, animated: true, completion: nil)
    }
}
