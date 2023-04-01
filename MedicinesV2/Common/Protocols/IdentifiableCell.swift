//
//  IdentifiableCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 01.04.2023.
//

/// Протокол для создания идентификатора ячейки
protocol IdentifiableCell {
    
}

extension IdentifiableCell {
    static var identifier: String {
        String(describing: Self.self)
    }
}
