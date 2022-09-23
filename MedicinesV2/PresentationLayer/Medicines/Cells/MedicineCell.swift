//
//  MedicineCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

class MedicineCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var trashLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // FIXME: После тестирования удалить, если всё будет работать правильно
        // Изменил настройки ячейки, нужно тестирование
//        trashLabel.isHidden = true
    }
}

// MARK: - Public method

extension MedicineCell {
    
    /// Настройка информации, которая будет отображаться в ячейке лекарства
    /// - Parameters:
    ///   - name: принимает название лекарства
    ///   - type: принимает тип лекарства
    ///   - expiryDate: принимает дату срока годности лекарства
    ///   - amount: принимает количество оставшегося лекарства
    func configure (
        name: String,
        type: String?,
        expiryDate: Date?,
        amount: NSNumber?
    ) {
        setAlertLabel(isAlertLabelPresent: false)
        
        nameLabel.text = name
        typeLabel.text = type
        expiryDateLabel.text = expiryDate?.toString()
        amountLabel.text = "\(amount ?? 0) шт"
        
        if Date() >= expiryDate ?? Date() {
            setAlertLabel(title: "В мусор", isAlertLabelPresent: true)
        }
        
        if amount?.doubleValue ?? 0 <= 0 {
            setAlertLabel(title: "Купить", isAlertLabelPresent: true)
        }
    }
    
    /// Настройка лейбла предупреждения
    /// - Parameters:
    ///   - title: принимает заголовок, который будет отображаться в лейбле предупреждения
    ///   - alertLabelPresent: при значении true выводит лейбл предупреждения из скрытия
    func setAlertLabel(
        title: String? = nil,
        isAlertLabelPresent: Bool
    ) {
        trashLabel.text = title
        trashLabel.isHidden = !isAlertLabelPresent
    }
}

// MARK: - Конфигурирование ячейки

private extension MedicineCell {
    ///  Метод инициализации настроек
    func setup() {
        setupLabels()
    }
    
    /// Метод для настройки лейблов
    func setupLabels() {
        trashLabel.layer.cornerRadius = 5
        trashLabel.clipsToBounds = true
    }
}
