//
//  MenuIcons.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 08.03.2023.
//

import UIKit

enum MenuIcons {
    // System icons
    case gear
    case book
    
    var image: UIImage? {
        UIImage(named: self.systemIcons)
    }
}

// MARK: - System Icons

private extension MenuIcons {
    var systemIcons: String {
        switch self {
        case .gear:
            return "gear"
        case .book:
            return "book.fill"
        }
    }
}
