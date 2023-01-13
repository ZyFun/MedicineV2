//
//  MenuModel.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.01.2023.
//

import UIKit

#warning("отрефакторить, возможно стоит сделать структурой и передавать из неё массив")
enum MenuModel: Int, CustomStringConvertible {
    
    case settings
    case contacts
    
    var description: String {
        switch self {
        case .settings:
            return "Настройки"
        case .contacts:
            return "Контакты"
        }
    }
    
    var image: UIImage {
        switch self {
        case .settings:
            return UIImage(systemName: "gear") ?? UIImage()
        case .contacts:
            return UIImage(systemName: "book.fill") ?? UIImage()
        }
    }
}
