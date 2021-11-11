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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        medicineName.text = ""
    }
    
}
