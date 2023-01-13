//
//  MenuModel.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.01.2023.
//

import UIKit

struct MenuModel {
    let iconImage: UIImage
    let title: String
    
    static func getMenu() -> [MenuModel] {
        [
            MenuModel(
                iconImage: UIImage(systemName: "gear") ?? UIImage(),
                title: "Настройки"
            ),
            
            MenuModel(
                iconImage: UIImage(systemName: "book.fill") ?? UIImage(),
                title: "Контакты"
            )
        ]
    }
    
}
