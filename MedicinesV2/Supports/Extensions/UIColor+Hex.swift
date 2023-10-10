//
//  UIColor+Hex.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 02.04.2023.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexWithoutPrefix = hex
        if hex.hasPrefix("#") {
            hexWithoutPrefix = String(hex.dropFirst())
        }
        let scanner = Scanner(string: hexWithoutPrefix)
        var hexValue: UInt64 = 0
        scanner.scanHexInt64(&hexValue)
        
        let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hexValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
