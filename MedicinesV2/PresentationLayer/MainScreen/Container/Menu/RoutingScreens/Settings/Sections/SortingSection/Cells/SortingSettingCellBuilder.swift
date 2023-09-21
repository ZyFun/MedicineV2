//
//  SortingSettingCellBuilder.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.05.2023.
//

import UIKit

final class SortingSettingCellBuilder {
    private let height: CGFloat
    private let viewModels: [SortingSettingCellModel]
    private weak var delegate: SortingCellDelegate?
    
    init(
        height: CGFloat,
        viewModels: [SortingSettingCellModel],
        delegate: SortingCellDelegate?
    ) {
        self.height = height
        self.viewModels = viewModels
        self.delegate = delegate
    }
}

// MARK: - TableViewCellBuilderProtocol

extension SortingSettingCellBuilder: TableViewCellBuilderProtocol {
    func register(tableView: UITableView) {
        tableView.register(
            SortingSettingCell.self,
            forCellReuseIdentifier: SortingSettingCell.identifier
        )
    }
    
    func cellHeight() -> CGFloat { height }
    
    func cellCount() -> Int { viewModels.count }
    
    func cellAt(tableView: UITableView, indexPath: IndexPath ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SortingSettingCell.identifier,
            for: indexPath
        ) as? SortingSettingCell else { return UITableViewCell() }
        
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        cell.sortingCellDelegate = delegate
        
        return cell
    }
}
