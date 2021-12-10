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
    @IBOutlet weak var medicineTypeTextField: UITextField!
    @IBOutlet weak var medicineAmountTextField: UITextField!
    @IBOutlet weak var medicineCountStepsTextField: UITextField!
    @IBOutlet weak var medicinesExpiryDataTextField: UITextField!
    
    @IBOutlet weak var medicineAmountStepper: UIStepper!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

}

//// MARK: - Table view data source
//// MARK: - Table view delegate

// MARK: - Text Field Delegate
extension MedicineTableViewController: UITextFieldDelegate {
    // Назначаю действия для кноаки Done на клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        medicineCountStepsTextField.resignFirstResponder()
        doneButtonPressed()
        return true
    }
    
    // Функция для ограничения ввода символов и точек с запятыми
    // Выглядит как костыль но работает.
    // TODO: Нужно подумать как это можно улучшить.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

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

// MARK: - Инициализация ViewController
private extension MedicineTableViewController {
    /// Метод инициализации VC
    func setup() {
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
        medicineCountStepsTextField.delegate = self
        medicineCountStepsTextField.clearsOnBeginEditing = true
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
        // Извлекаем принудительно, так как расширение в любом случае вернет 0
        medicineAmountStepper.value = medicineAmountTextField.text!.doubleValue
        medicineAmountStepper.stepValue = medicineCountStepsTextField.text!.doubleValue
        medicineAmountStepper.minimumValue = 0
        medicineAmountStepper.maximumValue = 999
    }
    
    /// Загрузка лекарства из базы
    func loadMedicine() {
        if let medicine = medicine {
            medicineNameTextField.text = medicine.title
            medicineTypeTextField.text = medicine.type
            medicineAmountTextField.text = String(medicine.amount)
            medicineCountStepsTextField.text = String(medicine.stepCountForStepper)
            medicinesExpiryDataTextField.text = "\(medicine.expiryDate?.toString() ?? Date().toString())"
        }
    }
    
    // MARK: Actions
    @IBAction func stepMedicineCount(_ sender: UIStepper) {
        medicineAmountTextField.text = String(sender.value)
    }
    
    /// Кнопка готово на родной клавиатуре
    func doneButtonPressed() {
        // Извлекаем принудительно, так как расширение в любом случае вернет 0
        var stepCount = medicineCountStepsTextField.text!.doubleValue
        
        // Защита от введения нуля пользователем и расширением NumberFormatter.
        // При значении 0 у степпера, приложение падает.
        if stepCount == 0 {
            stepCount = 1
        }
        // Нужно для того, чтобы сохранить значение в базу
        // которое было введено в поле шага степпера.
        medicine?.stepCountForStepper = stepCount
        StorageManager.shared.saveContext()
        // Эта строчка нужна для того, чтобы обновить значение в поле ввода
        // и отобразить введенноё число в формате с точкой,
        // если было введено целое число
        medicineCountStepsTextField.text = String(stepCount)
        medicineAmountStepper.stepValue = stepCount
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
        
        // Если лекарство есть в базе, меняем его параметры.
        // Если это новое лекарство, сохраняем введенные значения.
        if let medicine = medicine {
            medicine.title = medicineNameTextField.text
            medicine.type = medicineTypeTextField.text
            // Извлекаем принудительно, так как расширение в любом случае вернет 0
            medicine.amount = medicineAmountTextField.text!.doubleValue
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
