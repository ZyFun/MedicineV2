//
//  NotificationSettingCellBuilder.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.05.2023.
//

import UIKit

final class NotificationSettingCellBuilder {
    private let height: CGFloat
    private let viewModels: [NotificationSettingCellModel]
    private weak var delegate: NotificationCellDelegate?
    
    init(
        height: CGFloat,
        viewModels: [NotificationSettingCellModel],
        delegate: NotificationCellDelegate?
    ) {
        self.height = height
        self.viewModels = viewModels
        self.delegate = delegate
    }
}

// MARK: - TableViewCellBuilderProtocol

extension NotificationSettingCellBuilder: TableViewCellBuilderProtocol {
    func register(tableView: UITableView) {
        tableView.register(
            NotificationSettingCell.self,
            forCellReuseIdentifier: NotificationSettingCell.identifier
        )
    }
    
    func cellHeight() -> CGFloat { height }
    
    func cellCount() -> Int { viewModels.count }
    
    func cellAt(tableView: UITableView, indexPath: IndexPath ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationSettingCell.identifier,
            for: indexPath
        ) as? NotificationSettingCell else { return UITableViewCell() }
        
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        cell.notificationCellDelegate = delegate
        
        return cell
    }
}
