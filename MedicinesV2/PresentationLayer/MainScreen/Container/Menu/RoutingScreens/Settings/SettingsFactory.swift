//
//  SettingsFactory.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.05.2023.
//

import UIKit

final class SettingsFactory {
    // MARK: - Private properties
    
    private let tableView: UITableView
    private var sections: [SettingSections]
    private var tableViewAdapter: TableViewAdapter?
    private weak var notificationDelegate: NotificationCellDelegate?
    private weak var sortingDelegate: SortingCellDelegate?
    
    init(
        tableView: UITableView,
        sections: [SettingSections],
        notificationDelegate: NotificationCellDelegate?,
        sortingDelegate: SortingCellDelegate?
    ) {
        self.tableView = tableView
        self.sections = sections
        self.notificationDelegate = notificationDelegate
        self.sortingDelegate = sortingDelegate
        
        setupTableView()
    }
    
    /// Обновляет секции
    func update(sections: [SettingSections]) {
        self.sections = sections
        tableViewAdapter?.configure(with: createSections())
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        tableViewAdapter = TableViewAdapter(tableView: tableView)
        
        tableView.dataSource = tableViewAdapter
        tableView.delegate = tableViewAdapter

        tableViewAdapter?.configure(with: createSections())
    }
    
    /// Создает секцию
    ///  - Parameter type: тип секции
    ///  - Returns: объект протокола строителя секции
    private func createBuilder(type: SettingSections) -> TableViewSectionProtocol {
        switch type {
        case .notification(let viewModel):
            let configurator = NotificationSectionConfigurator(
                viewModels: viewModel.viewModels,
                heightCell: 45,
                typeHeader: .base(viewModel.titleSection),
                delegate: notificationDelegate
            )
            return configurator.configure(for: tableView)
        case .sorting(let viewModel):
            let configurator = SortingSectionConfigurator(
                viewModels: viewModel.viewModels,
                heightCell: 45,
                typeHeader: .base(viewModel.titleSection),
                delegate: sortingDelegate
            )
            return configurator.configure(for: tableView)
        }
    }
}

// MARK: - TableViewFactoryProtocol

extension SettingsFactory: TableViewFactoryProtocol {
    func createSections() -> [TableViewSectionProtocol] {
        sections.map { createBuilder(type: $0) }
    }
}
