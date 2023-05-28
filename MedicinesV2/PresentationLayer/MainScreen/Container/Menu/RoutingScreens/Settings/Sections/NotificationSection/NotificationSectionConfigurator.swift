//
//  NotificationSectionConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.05.2023.
//

import UIKit

final class NotificationSectionConfigurator {
    private let viewModels: [NotificationSettingCellModel]
    private weak var delegate: NotificationCellDelegate?
    
    let heightCell: CGFloat
    let typeHeader: TypeOfHeader?
    
    init(
        viewModels: [NotificationSettingCellModel],
        heightCell: CGFloat,
        typeHeader: TypeOfHeader?,
        delegate: NotificationCellDelegate?
    ) {
        self.viewModels = viewModels
        self.heightCell = heightCell
        self.typeHeader = typeHeader
        self.delegate = delegate
    }
}

// MARK: - TableViewSectionConfiguration

extension NotificationSectionConfigurator: TableViewSectionConfiguration {
    
    func configure(for tableView: UITableView) -> TableViewSectionProtocol {
        // Конфигурируем билдер заголовка
        var headerBuilder: TableViewSectionHeaderBuilder?
        if let typeHeader = typeHeader {
            headerBuilder = TableViewSectionHeaderBuilder(type: typeHeader)
        }
        
        // Конфигурируем билдер и регистрируем ячейки
        let cellBuilder = NotificationSettingCellBuilder(
            height: heightCell,
            viewModels: viewModels,
            delegate: delegate
        )
        cellBuilder.register(tableView: tableView)
        
        // Конфигурируем секцию
        let section = TableViewSectionBuilder(
            headerBuilder: headerBuilder,
            cellBuilder: cellBuilder
        )
        return section
    }
}
