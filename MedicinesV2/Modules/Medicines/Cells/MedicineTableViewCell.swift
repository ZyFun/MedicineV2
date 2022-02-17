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
}

// MARK: - Public method
extension MedicineTableViewCell {
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
}

// MARK: Конфигурирование ячейки
private extension MedicineTableViewCell {
    ///  Метод инициализации настроек
    func setup() {
        setupLabels()
    }
    
    /// Метод для настройки лейблов
    func setupLabels() {
        trashLabel.text = "В мусор"
        trashLabel.isHidden = true
        trashLabel.layer.cornerRadius = 5
        trashLabel.clipsToBounds = true
    }
}
