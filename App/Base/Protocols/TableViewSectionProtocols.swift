//
//  TableViewSectionProtocols.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 17.05.2023.
//

import UIKit

/// Протокол фабрики для TableView
protocol TableViewFactoryProtocol {
    /// Создает секции
    func createSections() -> [TableViewSectionProtocol]
}

/// Протокол конфигурации секции таблицы
protocol TableViewSectionConfiguration {
    /// Конфигурирует и возвращает секцию
    func configure(for tableView: UITableView) -> TableViewSectionProtocol
}

/// Протокол вью-модели секции таблицы
protocol TableViewSectionProtocol {
    var headerBuilder: TableViewHeaderBuilderProtocol? { get }
    var cellBuilder: TableViewCellBuilderProtocol { get }
    
    init(
        headerBuilder: TableViewHeaderBuilderProtocol?,
        cellBuilder: TableViewCellBuilderProtocol
    )
}

/// Протокол строителя ячейки таблицы
protocol TableViewCellBuilderProtocol {
    /// Регистрирует ячейку в таблице
    func register(tableView: UITableView)
    
    /// Возвращает высоту ячейки
    func cellHeight() -> CGFloat
    
    /// Возвращает количество ячеек
    func cellCount() -> Int
    
    /// Создает ячейку по indexPath
    func cellAt(
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell
    
    /// Возвращает высоту нижнего колонтитула секции
    func heightFooter() -> CGFloat
}

/// Протокол строителя ячейки таблицы с опцией выбора ячейки
protocol TableViewSelectableCellBuilderProtocol: TableViewCellBuilderProtocol {
    /// Метод для выбора ячейки
    /// - Parameter indexPath: Параметр пути ячейки по IndexPath
    func cellSelected(indexPath: IndexPath)
}

extension TableViewCellBuilderProtocol {
    func heightFooter() -> CGFloat {
        return 16
    }
}

/// Протокол строителя заголовка таблицы
protocol TableViewHeaderBuilderProtocol {
    /// Возвращает высоту заголовка
    func headerHeight() -> CGFloat
    
    /// Определяет вью для заголовка секции таблицы
    func viewForHeaderInSection(
        tableView: UITableView,
        section: Int
    ) -> UIView?
}
