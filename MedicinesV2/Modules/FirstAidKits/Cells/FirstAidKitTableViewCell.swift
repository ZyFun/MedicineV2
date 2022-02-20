//
//  FirstAidKitTableViewCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 23.12.2021.
//

import UIKit

/// Ячейка для аптечки
final class FirstAidKitTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleFirstAidKit: UILabel!
    @IBOutlet weak var amountMedicines: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}

// MARK: - Конфигурирование ячейки
private extension FirstAidKitTableViewCell {
    /// Метод инициализации настроек ячейки
    func setup() {
        setupUI()
    }
    
    /// Метод для настройки отображения элементов
    func setupUI() {
        amountMedicines.textColor = .lightGray
        accessoryType = .disclosureIndicator
    }
}

// MARK: - Publik Methods
extension FirstAidKitTableViewCell {
    /// Метод для конфигурирования отображаемой информации в ячейке.
    /// - Parameters:
    ///   - titleFirstAidKit: принимает название аптечки.
    ///   - amountMedicines: принимает количество лекарств, хранящихся  в аптечке.
    func configure(titleFirstAidKit: String?, amountMedicines: String) {
        self.titleFirstAidKit.text = titleFirstAidKit
        self.amountMedicines.text = amountMedicines
    }
}
