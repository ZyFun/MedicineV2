//
//  FirstAidKitTableViewCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 23.12.2021.
//

import UIKit

class FirstAidKitTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var titleFirstAidKit: UILabel!
    @IBOutlet weak var amountMedicines: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Setup
    /// Метод для настройки отображения элементов
    func setupUI() {
        amountMedicines.textColor = .lightGray
    }
    
    func configure(titleFirstAidKit: String, amountMedicines: String) {
        self.titleFirstAidKit.text = titleFirstAidKit
        self.amountMedicines.text = amountMedicines
    }
}
