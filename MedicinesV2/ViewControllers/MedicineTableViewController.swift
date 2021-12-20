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
    
    // MARK: Private Properties
    private var datePicker: UIDatePicker!
    
    // MARK: IB Outlets
    @IBOutlet weak var medicineNameTextField: UITextField!
    @IBOutlet weak var medicineTypeTextField: UITextField!
    @IBOutlet weak var medicineAmountTextField: UITextField!
    @IBOutlet weak var medicineCountStepsTextField: UITextField!
    @IBOutlet weak var medicinesExpiryDateTextField: UITextField!
    
    @IBOutlet weak var medicineAmountStepper: UIStepper!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

}

// MARK: - Настройки для ViewController
private extension MedicineTableViewController {
    /// Метод инициализации VC
    func setup() {
        setupNavigationBar()
        setupTableView()
        setupDataPicker()
        setupTextFields()
        loadMedicine()
        setupStepperMedicine()
    }
    
    /// Настройка navigation bar
    func setupNavigationBar() {
        // Возможно потребуется, когда вход в приложение будет без сториборда, если нет, удалить
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = medicine?.title ?? "Новое лекарство"
        addButtonsToNavigationBar()
    }
    
    /// Настройка внешнего вида таблицы
    func setupTableView() {
        tableView.allowsSelection = false
    }
    
    /// Конфигурирование полей ввода текста
    func setupTextFields() {
        setupDelegateForTextFields()
        
        // Настройка поля ввода количества шагов, которое используется в степпере
        medicineCountStepsTextField.clearsOnBeginEditing = true
        medicineCountStepsTextField.keyboardType = .decimalPad
        medicineCountStepsTextField.returnKeyType = .done
        
        // Настройка поля ввода количества оставшихся лекарств
        medicineAmountTextField.keyboardType = .decimalPad
        
        // Настройка поля ввода с кастомным способом выбора даты
        medicinesExpiryDateTextField.inputView = datePicker
    }
    
    /// Настройка делегирования для полей ввода
    func setupDelegateForTextFields() {
        medicineNameTextField.delegate = self
        medicineTypeTextField.delegate = self
        medicineCountStepsTextField.delegate = self
        medicineAmountTextField.delegate = self
        medicinesExpiryDateTextField.delegate = self
    }
    
    /// Добавление кнопок в navigation bar
    func addButtonsToNavigationBar() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveButtonPressed))
        
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    /// Конфигурирование степпера
    func setupStepperMedicine() {
        // Извлекаем принудительно, так как расширение в любом случае вернет 0
        medicineAmountStepper.value = medicineAmountTextField.text!.doubleValue
        medicineAmountStepper.stepValue = medicineCountStepsTextField.text!.doubleValue
        medicineAmountStepper.minimumValue = 0
        medicineAmountStepper.maximumValue = 999
    }
    
    /// Настройка и конфигурации  кастомного datePicker для выбора даты с помощью барабана
    func setupDataPicker() {
        datePicker = UIDatePicker(
            frame: CGRect(
                x: 0,
                y: 0,
                width: self.view.bounds.width,
                height: 280
            )
        )
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(
            self,
            action: #selector(dateChanged),
            for: .allEvents
        )
        
        // Выбираем стиль в виде барабана для новых версий iOS
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    /// Загрузка лекарства из базы
    func loadMedicine() {
        if let medicine = medicine {
            medicineNameTextField.text = medicine.title
            medicineTypeTextField.text = medicine.type
            medicineAmountTextField.text = String(medicine.amount)
            medicineCountStepsTextField.text = String(medicine.stepCountForStepper)
            medicinesExpiryDateTextField.text = "\(medicine.expiryDate?.toString() ?? Date().toString())"
        }
    }
    
    /// Метод добавляет тулбар на клавиатуру для определенного поля редактирования.
    /// - Parameter textField: принимает поле, для клавиатуры которого
    /// требуется добавить тулбар.
    func addToolbarForKeyboard(for textField: UITextField) {
        let toolbar = UIToolbar(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.bounds.width,
                height: 44
            )
        )
        
        let leftSpeсing = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(toolBarDoneButtonPressed)
        )
        
        toolbar.setItems([leftSpeсing, doneButton], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    // MARK: Actions
    /// Назначает действий при окончании редактирования в поле ввода
    /// - Parameter textField: принимает поле ввода в котором необходимо применить
    ///  действие по окончанию редактирования
    func actionsEndEditing(for textField: UITextField) {
        // Делаю первой проверку именно на это поле, потому что
        // нет необходимости в присвоении переменных
        if textField == medicinesExpiryDateTextField {
            textField.resignFirstResponder()
            return
        }
        
        // Извлекаем принудительно, так как расширение в любом случае вернет 0
        var amountMedicine = textField.text!.doubleValue
        
        if textField == medicineCountStepsTextField {
            // Защита от введения нуля пользователем и расширением NumberFormatter.
            // При значении 0 у степпера, приложение падает.
            if amountMedicine == 0 {
                amountMedicine = 1
            }
            // Эта строчка нужна для того, чтобы обновить значение в поле ввода
            // и отобразить введенноё число в формате с точкой,
            // если было введено целое число
            textField.text = String(format: "%.2f", amountMedicine)
            medicineAmountStepper.stepValue = amountMedicine
        }
        
        if textField == medicineAmountTextField {
            textField.text = String(format: "%.2f", amountMedicine)
            medicineAmountStepper.value = amountMedicine
        }
        
        textField.resignFirstResponder()
    }
    
    // Действия для степпера
    @IBAction func stepMedicineCount(_ sender: UIStepper) {
        medicineAmountTextField.text = String(format: "%.2f", sender.value)
    }
    
    /// Действие кнопки готово для тулбара
    @objc func toolBarDoneButtonPressed() {
        if medicineAmountTextField.isFirstResponder {
            actionsEndEditing(for: medicineAmountTextField)
            return
        }

        if medicineCountStepsTextField.isFirstResponder {
            actionsEndEditing(for: medicineCountStepsTextField)
            return
        }
        
        if medicinesExpiryDateTextField.isFirstResponder {
            actionsEndEditing(for: medicinesExpiryDateTextField)
            return
        }
    }
    
    /// Изменение даты с помощью dataPicker
    @objc private func dateChanged() {
        medicinesExpiryDateTextField.text = datePicker.date.toString()
    }
    
    /// Действие сохранения для кнопки навигационной панели
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
        
        // Создание связи лекарства к аптечке.
        // Это работает, осталось только понять, как отфильтовать предикатом
        if let currentFirstAidKit = currentFirstAidKit {
            medicine?.firstAidKit = currentFirstAidKit
        }
        
        // Если лекарство есть в базе, меняем его параметры.
        // Если это новое лекарство, сохраняем введенные значения.
        if let medicine = medicine {
            medicine.dateCreated = Date()
            medicine.title = medicineNameTextField.text
            medicine.type = medicineTypeTextField.text
            // Извлекаем принудительно, так как расширение в любом случае вернет 0
            medicine.amount = medicineAmountTextField.text!.doubleValue
            // Расширение возвращает 0, но с 0 будет краш приложения
            // при открытии такого лекарства. По этому, значение по умолчанию 1.
            medicine.stepCountForStepper = medicineCountStepsTextField.text?.doubleValue ?? 1
            medicine.expiryDate = medicinesExpiryDateTextField.text?.toDate()
        }
        
        return true
    }
}

//// MARK: - Table view data source
//// MARK: - Table view delegate

// MARK: - Text Field Delegate
extension MedicineTableViewController: UITextFieldDelegate {
    // Используется для отображения тулбара
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == medicineCountStepsTextField {
            addToolbarForKeyboard(for: textField)
            return
        }
        
        if textField == medicineAmountTextField {
            addToolbarForKeyboard(for: textField)
            return
        }
        
        if textField == medicinesExpiryDateTextField {
            addToolbarForKeyboard(for: textField)
            datePicker.date = medicinesExpiryDateTextField.text?.toDate() ?? Date()
            return
        }
    }
    
    // Назначаю действия по окончанию редактирования поля
    func textFieldDidEndEditing(_ textField: UITextField) {
        actionsEndEditing(for: textField)
    }
    
    // Назначаю действия для кнопки Return на клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Функция для ограничения ввода символов и точек с запятыми
    // Выглядит как костыль но работает.
    // TODO: Нужно подумать как это можно улучшить.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField != medicineAmountTextField,
           textField != medicineCountStepsTextField {
            return true
        }
        
        guard let currentText = textField.text else { return false }
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count <= 6 && string != "." && string != "," {
            return true
        } else {
            if updatedText.count <= 4 && string == "." || string == "," {
                let countDots = currentText.components(separatedBy: [".", ","]).count - 1
                if countDots == 0 {
                    return true
                } else {
                    if countDots > 0 || string == "." || string == "," {
                        return false
                    } else {
                        return true
                    }
                }
            } else {
                return false
            }
        }
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
