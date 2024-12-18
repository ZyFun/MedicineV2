//
//  SystemIcons.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 02.04.2023.
//

import UIKit

/// Изображения системных иконок
enum SystemIcons: String {
    // Cell action icons
    case editIcon = "pencil"
    case deleteIcon = "trash"
    case cart = "cart"
    
    // Alert icon cell
    case alert = "exclamationmark.triangle"
    
    // Default image first aid kit
    case firstAidKit = "cross.case"
    
    // Default image medicine
    case pills = "pills.fill"
    
    // Menu icons
    case gear = "gear"
    case book = "book.fill"
}

extension SystemIcons {
    func roundIconRendering(color: UIColor?, diameter: Double) -> UIImage? {
        var imageButton: UIImage? {
            let largeConfig = UIImage.SymbolConfiguration(
                pointSize: 15.0,
                weight: .medium,
                scale: .large
            )
            
            return UIImage(
                systemName: self.rawValue,
                withConfiguration: largeConfig
            )?.withTintColor(
                .white,
                renderingMode: .alwaysTemplate
            ).addBackgroundCircle(color: color, diameter: diameter)
        }
        
        return imageButton
    }
    
    var image: UIImage? {
        UIImage(systemName: self.rawValue)
    }
}
