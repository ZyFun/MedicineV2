//
//  TableViewSectionHeaderBuilder.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.05.2023.
//

import UIKit

enum TypeOfHeader {
    /// Основной (только название)
    /// - По умолчанию, расчет высоты производится на основе высоты лейбла с текстом.
    case base(_ title: String, height: CGFloat? = .none)
}

final class TableViewSectionHeaderBuilder {
    private let type: TypeOfHeader
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.systemNormal(.titleSize).font
        label.textColor = Colors.darkCyan
        return label
    }()
    
    /// - Parameter type: тип заголовка
    init(type: TypeOfHeader) {
        self.type = type
    }
}

// MARK: - TableViewHeaderBuilderProtocol

extension TableViewSectionHeaderBuilder: TableViewHeaderBuilderProtocol {
    func headerHeight() -> CGFloat {
        switch type {
        case let .base(title, height):
            if let height {
                return height
            } else {
                titleLabel.text = title
                let maxSize = CGSize(
                    width: UIScreen.main.bounds.width,
                    height: CGFloat.greatestFiniteMagnitude
                )
                let height = titleLabel.sizeThatFits(maxSize).height + 20
                return height
            }
        }
    }
    
    func viewForHeaderInSection(tableView: UITableView, section: Int) -> UIView? {
        switch type {
        case let .base(title, _):
            titleLabel.text = title
            return titleLabel
        }
    }
}
