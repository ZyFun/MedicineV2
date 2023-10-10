//
//  BaseTableViewCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.05.2023.
//

import UIKit

/// Протокол для создания идентификатора ячейки
protocol IdentifiableCell {}

extension IdentifiableCell {
    static var identifier: String {
        String(describing: Self.self)
    }
}

/// Абстрактный класс ячейки таблицы
class BaseTableViewCell: UITableViewCell, IdentifiableCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell() {}
}
