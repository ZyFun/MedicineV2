//
//  FirstAidKitCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 23.12.2021.
//

import UIKit

/// Ячейка для аптечки
final class FirstAidKitCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var titleFirstAidKitLabel: UILabel!
    @IBOutlet weak var amountMedicinesLabel: UILabel!
    @IBOutlet weak var expiredMedicinesCountLabel: UILabel!
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
}

// MARK: - Publik Methods

extension FirstAidKitCell {
    /// Метод для конфигурирования отображаемой информации в ячейке.
    /// - Parameters:
    ///   - titleFirstAidKit: принимает название аптечки.
    ///   - amountMedicines: принимает количество лекарств, хранящихся  в аптечке.
    func configure(titleFirstAidKit: String?, amountMedicines: String, expiredCount: Int) {
        self.titleFirstAidKitLabel.text = titleFirstAidKit
        self.amountMedicinesLabel.text = amountMedicines
        
        if expiredCount != 0 {
            expiredMedicinesCountLabel.text = "Просроченных лекарств: \(expiredCount)"
            expiredMedicinesCountLabel.textColor = #colorLiteral(red: 0.8729341626, green: 0.4694843888, blue: 0.5979845524, alpha: 1)
        } else {
            expiredMedicinesCountLabel.text = "Все лекарства в порядке"
            expiredMedicinesCountLabel.textColor = #colorLiteral(red: 0.4078431373, green: 0.8156862745, blue: 0.6823529412, alpha: 1)
        }
        
    }
}

// MARK: - Конфигурирование ячейки

private extension FirstAidKitCell {
    /// Метод инициализации настроек ячейки
    func setup() {
        setupUI()
    }
    
    /// Метод для настройки отображения элементов
    func setupUI() {
        amountMedicinesLabel.textColor = .lightGray
        accessoryType = .disclosureIndicator
    }
}
