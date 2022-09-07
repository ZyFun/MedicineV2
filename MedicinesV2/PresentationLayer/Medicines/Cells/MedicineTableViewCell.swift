//
//  MedicineTableViewCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {

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
        
        // Без этого, при возврате с предыдущего экрана начинает отображаться
        // лейбл о просрочке, там где это не нужно.
        trashLabel.isHidden = true
    }
}

// MARK: - Public method
extension MedicineTableViewCell {
    
    /// Настройка информации, которая будет отображаться в ячейке лекарства
    /// - Parameters:
    ///   - name: принимает название лекарства
    ///   - type: принимает тип лекарства
    ///   - expiryDate: принимает дату срока годности лекарства
    ///   - amount: принимает количество оставшегося лекарства
    func configure (
        name: String,
        type: String,
        expiryDate: String,
        amount: String
    ) {
        nameLabel.text = name
        typeLabel.text = type
        expiryDateLabel.text = expiryDate
        amountLabel.text = "\(amount) шт"
    }
    
    /// Настройка лейбла предупреждения
    /// - Parameters:
    ///   - title: принимает заголовок, который будет отображаться в лейбле предупреждения
    ///   - alertLabelPresent: при значении true выводит лейбл предупреждения из скрытия
    func configureAlertLabel(
        title: String,
        isAlertLabelPresent: Bool
    ) {
        trashLabel.text = title
        trashLabel.isHidden = !isAlertLabelPresent
    }
}

// MARK: Конфигурирование ячейки
private extension MedicineTableViewCell {
    ///  Метод инициализации настроек
    func setup() {
        setupLabels()
    }
    
    /// Метод для настройки лейблов
    func setupLabels() {
        trashLabel.isHidden = true
        trashLabel.layer.cornerRadius = 5
        trashLabel.clipsToBounds = true
    }
}
