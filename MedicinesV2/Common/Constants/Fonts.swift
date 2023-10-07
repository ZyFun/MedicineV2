//
//  Fonts.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.05.2023.
//

import UIKit

enum Fonts {
    case systemNormal(_ size: FontSize)
    case systemBold(_ size: FontSize)
    
    var font: UIFont {
        switch self {
        case .systemNormal(let size): UIFont.systemFont(ofSize: size.size)
        case .systemBold(let size): UIFont.boldSystemFont(ofSize: size.size)
        }
    }
}

enum FontSize {
    case titleSize
    case defaultSize
    case size1
    case size2
    case size3
    
    var size: CGFloat {
        switch self {
        case .defaultSize: 17.0
        case .titleSize: 19.0
        case .size1: 26.0
        case .size2: 20.0
        case .size3: 15.0
        }
    }
}
