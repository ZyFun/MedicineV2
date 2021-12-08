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
    
    /// Используется для хранения и передачи шага в степпер
    private var stepsCount: Double = 1
    
    // MARK: IB Outlets
    @IBOutlet weak var medicineNameTextField: UITextField!
    @IBOutlet weak var medicineTypeTextField: UITextField!
    @IBOutlet weak var medicineAmountTextField: UITextField!
    @IBOutlet weak var medicineCountStepsTextField: UITextField!
    @IBOutlet weak var medicinesExpiryDataTextField: UITextField!
    
    @IBOutlet weak var medicineAmountStepsStepper: UIStepper!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

}

// MARK: - Table view data source

// MARK: - Table view delegate

// MARK: - Text Field Delegate
extension MedicineTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        medicineCountStepsTextField.resignFirstResponder()
        doneButtonPressed()
        return true
    }
}

// MARK: - Инициализация ViewController
private extension MedicineTableViewController {
    /// Метод инициализации VC
    func setup() {
        medicineCountStepsTextField.delegate = self
        
        setupNavigationBar()
        setupTableView()
        setupTextFields()
        loadMedicine()
        setupStepperMedicine()
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
    
    /// Конфигурирование полей ввода текста
    func setupTextFields() {
        // Настройка поля ввода количества шагов, которое используется в степпере
        medicineCountStepsTextField.keyboardType = .numbersAndPunctuation
        medicineCountStepsTextField.returnKeyType = .done
    }
    
    /// Добавление кнопок в navigation bar
    func addButtons() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveButtonPressed))
        
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    /// Конфигурирование степпера
    func setupStepperMedicine() {
        medicineAmountStepsStepper.value = Double(medicineAmountTextField.text!) ?? 0
        medicineAmountStepsStepper.stepValue = Double(stepsCount)
        medicineAmountStepsStepper.minimumValue = 0
        medicineAmountStepsStepper.maximumValue = 999
    }
    
    /// Загрузка лекарства из базы
    func loadMedicine() {
        if let medicine = medicine {
            medicineNameTextField.text = medicine.title
            medicineTypeTextField.text = medicine.type
            medicineAmountTextField.text = String(medicine.amount)
            medicinesExpiryDataTextField.text = "\(medicine.expiryDate?.toString() ?? Date().toString())"
        }
    }
    
    // MARK: Actions
    @IBAction func stepMedicineCount(_ sender: UIStepper) {
        medicineAmountTextField.text = String(sender.value)
    }
    
    // Кнопка готово на родной клавиатуре
    func doneButtonPressed() {
        stepsCount = Double(medicineCountStepsTextField.text!) ?? 1
        // TODO: Написать и вызвать алерт с ошибкой, что в поле должно быть только число
        // Временный костыль. Эта строчка нужна для того, чтобы вернуть 1
        // В том случае, если в поле были введены не цифры
        medicineCountStepsTextField.text = String(stepsCount)
        medicineAmountStepsStepper.stepValue = Double(stepsCount)
    }
    
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
            showErrorAlert(errorMessage: "Поле с названием лекарства не должно быть пустым")
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
            medicine.type = medicineTypeTextField.text
            medicine.amount = Float(medicineAmountTextField.text!) ?? 0
            medicine.expiryDate = medicinesExpiryDataTextField.text?.toDate()
        }
        
        return true
    }
}

// MARK: - Error Alert Controller
private extension MedicineTableViewController {
    /// Алерт для отображения сообщения об ошибке.
    /// - Parameter errorMessage: принимает сообщение об ошибке,
    /// которое будет выведено на экран.
    func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: errorMessage,
            preferredStyle: .alert
        )
        
        let actionOk = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(actionOk)
        
        present(alert, animated: true, completion: nil)
    }
}
