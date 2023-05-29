//
//  SortingSectionConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.05.2023.
//

import UIKit

final class SortingSectionConfigurator {
    private let viewModels: [SortingSettingCellModel]
    private weak var delegate: SortingCellDelegate?
    
    let heightCell: CGFloat
    let typeHeader: TypeOfHeader?
    
    init(
        viewModels: [SortingSettingCellModel],
        heightCell: CGFloat,
        typeHeader: TypeOfHeader?,
        delegate: SortingCellDelegate?
    ) {
        self.viewModels = viewModels
        self.heightCell = heightCell
        self.typeHeader = typeHeader
        self.delegate = delegate
    }
}

// MARK: - TableViewSectionConfiguration

extension SortingSectionConfigurator: TableViewSectionConfiguration {
    
    func configure(for tableView: UITableView) -> TableViewSectionProtocol {
        // Конфигурируем билдер заголовка
        var headerBuilder: TableViewSectionHeaderBuilder?
        if let typeHeader = typeHeader {
            headerBuilder = TableViewSectionHeaderBuilder(type: typeHeader)
        }
        
        // Конфигурируем билдер и регистрируем ячейки
        let cellBuilder = SortingSettingCellBuilder(
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
