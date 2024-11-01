//
//  String+NumberFormatter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 08.12.2021.
//

import Foundation

// Дополнение для правильной записи точки вместо запятой с Decimal клавиатуры.
// Это нужно для обхода бага локализации. Английский регион отображает точку,
// а русский запятую. С запятой приложение крашится или в базу сохраняется 0,
// затирая старое значение.
extension String {
	static let numberFormatter: NumberFormatter = {
			let formatter = NumberFormatter()
			formatter.maximumFractionDigits = 2
			formatter.minimumFractionDigits = 2
			formatter.decimalSeparator = "."
			return formatter
		}()
    /// Преобразовывает текст в Double, а запятую в точку.
    /// Возвращает 0, если формат данных не удается преобразовать в числовой
    var doubleValue: Double {
        Self.numberFormatter.decimalSeparator = "."
        if let result = Self.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
			Self.numberFormatter.decimalSeparator = ","
            if let result = Self.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}
