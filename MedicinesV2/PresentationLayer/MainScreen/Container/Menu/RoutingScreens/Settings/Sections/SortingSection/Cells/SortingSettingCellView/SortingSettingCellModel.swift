//
//  SortingSettingCellModel.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.05.2023.
//

import Foundation

/// Модель данных для ячеек настройки сортировки
/// - Используется для формирования ячейки и меню выбора настройки
struct SortingSettingCellModel {
    let settingName: String
    var field: FieldSorting?
    var ascending: SortAscending?
    
    /// Перечесление с выбором направления поля сортировки
    enum FieldSorting: String {
        case title
        case dateCreated
        case expiryDate
        
        /// Содержит полное описание названия кейса
		var description: String {
			switch self {
			case .title: return String(localized: "По заголовку")
			case .dateCreated: return String(localized: "По дате добавления")
			case .expiryDate: return String(localized: "По сроку годности")
			}
		}
    }
    
    /// Перечисление с направлением сортировки
    enum SortAscending {
        case up
        case down
        
        var description: String {
            switch self {
            case .up: return String(localized: "По возрастанию")
            case .down: return String(localized: "По убыванию")
            }
        }
    }
}
