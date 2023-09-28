//
//  MedicineViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 01.12.2021.
//

import UIKit
import DTLogger

/// Протокол отображения ViewCintroller-a
protocol MedicineDisplayLogic: AnyObject {
    /// Алерт для отображения сообщения об ошибке.
    /// - Parameter errorMessage: принимает кейс с ошибкой.
    func showErrorAlert(errorMessage: UIAlertController.ErrorMessage)
}

final class MedicineViewController: UITableViewController {
    
    // MARK: - Public properties
    
    /// Ссылка на presenter
    var presenter: MedicineViewControllerOutput?
    /// Свойство содержащее в себе текущее лекарство
    /// - Если лекарство было передано в свойство, оно будет редактироваться
    /// - Если лекарства не было и это новое, будет создано новое
    var medicine: DBMedicine?
    /// Содержит в себе выбранную аптечку, для её связи с лекарствами
    var currentFirstAidKit: DBFirstAidKit?
    
    // MARK: - Dependencies
    
    var logger: DTLogger?
    
    // MARK: - Private Properties
    
    private var datePicker: UIDatePicker!
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var medicineNameTextField: UITextField!
    @IBOutlet weak var medicineTypeTextField: UITextField!
    @IBOutlet weak var medicinePurposeTextField: UITextField!
    @IBOutlet weak var medicineAmountTextField: UITextField!
    @IBOutlet weak var medicineCountStepsTextField: UITextField!
    @IBOutlet weak var medicinesExpiryDateTextField: UITextField!
    
    @IBOutlet weak var medicineAmountStepper: UIStepper!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Override methods
    
    override func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        // TODO: (#Explore) Непонятный баг, без этого отображаются заголовки которых нет
        CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        // TODO: (#Explore) Непонятный баг, без этого отображаются заголовки которых нет
        CGFloat.leastNonzeroMagnitude
    }
}

// MARK: - Настройки для ViewController

private extension MedicineViewController {
    
    /// Метод инициализации VC
    func setup() {
        setupNavigationBar()
        setupGestureRecognizer()
        setupTableView()
        setupDataPicker()
        setupTextFields()
        setDataFromDBMedicine()
        setupStepperMedicine()
    }
    
    // MARK: - Setup navigation bar
    
    /// Настройка navigation bar
    func setupNavigationBar() {
        title = medicine?.title ?? "Новое лекарство"
        addButtonsToNavigationBar()
    }
    
    /// Добавление кнопок в navigation bar
    func addButtonsToNavigationBar() {
        let saveButton = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(saveButtonPressed)
        )
        
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    /// Действие сохранения для кнопки навигационной панели
    @objc func saveButtonPressed() {
        // Служит для защиты, в случае попытки сохранить текст, который был вставлен
        // в поле ввода сторонней клавиатурой или копипастом.
        let medicineDose = medicineCountStepsTextField.text?.doubleValue ?? 1
        
        presenter?.createMedicine(
            name: medicineNameTextField.text,
            type: medicineTypeTextField.text,
            purpose: medicinePurposeTextField.text,
            amount: medicineAmountTextField.text,
            countSteps: "\(medicineDose)",
            expiryDate: medicinesExpiryDateTextField.text,
            currentFirstAidKit: currentFirstAidKit,
            medicine: medicine
        )
    }
    
    // MARK: - Setup gesture recognizer
    
    /// Настройка распознавания жестов.
    /// На данный момент используется для скрытия клавиатуры при тапе не по ячейке ввода.
    /// По каким то причинам более простой способ метода touchesBegan не работает
    func setupGestureRecognizer() {
        /// Жест, тап по экрану
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        
        view.addGestureRecognizer(tap)
    }
    
    /// Метод для скрытия клавиатуры при окончании редактирования данных
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Setup table view
    
    /// Настройка внешнего вида таблицы
    func setupTableView() {
        tableView.allowsSelection = false
        
        // TODO: (#Version) Удалить после прекращения поддержки iOS ниже 15
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Setup text fields
    
    /// Конфигурирование полей ввода текста
    func setupTextFields() {
        setupDelegateForTextFields()
        
        // Настройка поля ввода количества шагов, которое используется в степпере
        // Полное очищение поля нужно для удобства пользователя,
        // так-как значение этого поля при редактировании будет меняться полностью
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
        medicinePurposeTextField.delegate = self
        medicineCountStepsTextField.delegate = self
        medicineAmountTextField.delegate = self
        medicinesExpiryDateTextField.delegate = self
    }
    
    // MARK: - Setup stepper
    
    /// Конфигурирование степпера
    func setupStepperMedicine() {
        guard let value = medicineAmountTextField.text?.doubleValue else {
            logger?.log(.error, "Нет значения для степпера")
            return
        }
        guard let stepValue = medicineCountStepsTextField.text?.doubleValue else {
            logger?.log(.error, "Нет значения для шага степпера")
            return
        }
        
        medicineAmountStepper.value = value
        medicineAmountStepper.stepValue = setStepper(stepValue: stepValue)
        medicineAmountStepper.minimumValue = 0
        medicineAmountStepper.maximumValue = 999
        
        // TODO: (#Костыль) проверять работу с каждым обновлением Swift
        // решает проблему невозможности изменить tint color у степпера
        // начиная с iOS 13
        medicineAmountStepper.setDecrementImage(
            medicineAmountStepper.decrementImage(for: .normal),
            for: .normal
        )
        medicineAmountStepper.setIncrementImage(
            medicineAmountStepper.incrementImage(for: .normal),
            for: .normal
        )
        
        medicineAmountStepper.tintColor = Colors.darkCyan
    }
    
    // MARK: - Setup data picker
    
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
    
    /// Изменение даты с помощью dataPicker
    @objc private func dateChanged() {
        medicinesExpiryDateTextField.text = datePicker.date.toString()
    }
    
    // MARK: - Keyboard tools
    
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
        
        let leftSpacing = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(toolBarDoneButtonPressed)
        )
        
        toolbar.setItems([leftSpacing, doneButton], animated: false)
        textField.inputAccessoryView = toolbar
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
    
    // MARK: - IB Actions
    
    // Действия для степпера
    @IBAction func stepMedicineCount(_ sender: UIStepper) {
        medicineAmountTextField.text = String(format: "%.2f", sender.value)
    }
    
    // MARK: - Actions
    
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
        
        if textField == medicineCountStepsTextField {
            let amountMedicine = setStepper(
                stepValue: textField.text?.doubleValue ?? 1
            )
            
            textField.text = String(format: "%.2f", amountMedicine)
            medicineAmountStepper.stepValue = amountMedicine
        }
        
        if textField == medicineAmountTextField {
            guard let amountMedicine = textField.text?.doubleValue else {
                logger?.log(.error, "Нет значения количества лекарств")
                return
            }
            textField.text = String(format: "%.2f", amountMedicine)
            medicineAmountStepper.value = amountMedicine
        }
        
        textField.resignFirstResponder()
    }

    /// Заполнение свойств в поля лекарства из существующего выбранного лекарства
    func setDataFromDBMedicine() {
        if let medicine = medicine {
            let dbDoseMedicine = setStepper(
                stepValue: medicine.stepCountForStepper as? Double ?? 1
            )
            
            medicineNameTextField.text = medicine.title
            medicineTypeTextField.text = medicine.type
            medicinePurposeTextField.text = medicine.purpose
            medicineAmountTextField.text = "\(medicine.amount ?? 0)"
            medicineCountStepsTextField.text = "\(dbDoseMedicine)"
            medicinesExpiryDateTextField.text = "\(medicine.expiryDate?.toString() ?? "")"
        }
    }
    
    /// Метод для установки шага степпера
    /// - Служит для правильного назначения поля с защитой от 0 и отрицательного значения
    /// - Parameter stepValue: принимает дозу лекарства в качестве шага степпера
    /// - Returns: возвращает 0 или положительное значение
    func setStepper(stepValue: Double) -> Double {
        if stepValue == 0 {
            return 1
        } else {
            return abs(stepValue)
        }
    }
}

// MARK: - Text Field Delegate

extension MedicineViewController: UITextFieldDelegate {
    
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
    // FIXME: Нужно подумать как это можно улучшить.
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

// MARK: - Medicine Display Logic

extension MedicineViewController: MedicineDisplayLogic {
    
    func showErrorAlert(errorMessage: UIAlertController.ErrorMessage) {
        let alert = UIAlertController
            .createErrorAlertController(errorMessage: errorMessage)
        
        alert.actionError()
        
        present(alert, animated: true)
    }
}
