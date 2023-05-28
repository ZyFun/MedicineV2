//
//  SectionConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.05.2023.
//

import Foundation

/// Базовый конфигуратор секции
class SectionConfigurator {
    /// Высота ячейки
    let heightCell: CGFloat
    /// Тип заголовка
    let  typeHeader: TypeOfHeader?
    
    /// - Parameters:
    ///   - heightCell: Высота ячейки
    ///   - typeHeader: Тип заголовка
    init(heightCell: CGFloat,
         typeHeader: TypeOfHeader?) {
        self.heightCell = heightCell
        self.typeHeader = typeHeader
    }
}
