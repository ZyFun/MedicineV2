//
//  MedicineTableViewCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {

    @IBOutlet weak var medicineName: UILabel!
    
    func configure (text: String) {
        medicineName.text = text
    }
    
    // TODO: Разобраться, что это за метод
    // Как я понял, служит для обнуления контента в ячейке, но не понял зачем
    override func prepareForReuse() {
        super.prepareForReuse()
        medicineName.text = ""
    }
    
}
