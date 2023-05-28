//
//  Fonts.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.05.2023.
//

import UIKit

enum Fonts {
    case settings(_ size: SettingsFontSize)
    
    var font: UIFont {
        switch self {
        case .settings(let size):
            return UIFont.systemFont(ofSize: size.size)
        }
    }
}

enum SettingsFontSize {
    case titleSize
    case defaultSize
    
    var size: CGFloat {
        switch self {
        case .defaultSize: return 17.0
        case .titleSize: return 19.0
        }
    }
}
