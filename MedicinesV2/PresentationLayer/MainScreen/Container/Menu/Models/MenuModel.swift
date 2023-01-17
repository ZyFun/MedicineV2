//
//  MenuModel.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.01.2023.
//

import UIKit

enum MenuModel: Int, CaseIterable {
    case settings
    case aboutApp
    
    var title: String {
        switch self {
        case .settings:
            return "Настройки"
        case .aboutApp:
            return "О приложении"
        }
    }
    
    var iconImage: UIImage {
        switch self {
        case .settings:
            return UIImage(systemName: "gear") ?? UIImage()
        case .aboutApp:
            return UIImage(systemName: "book.fill") ?? UIImage()
        }
    }
}
