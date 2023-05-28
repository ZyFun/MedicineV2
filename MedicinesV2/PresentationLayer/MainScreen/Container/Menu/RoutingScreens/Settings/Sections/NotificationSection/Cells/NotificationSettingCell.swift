//
//  TimeCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.05.2023.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    typealias TimeNotification = NotificationSettingCellModel.TimeNotification
    
    func didSelectTimeNotification(time: TimeNotification)
    func didToggleSwitched(isRepeat: Bool)
}

final class NotificationSettingCell: BaseTableViewCell {
    typealias TimeNotification = NotificationSettingCellModel.TimeNotification
    
    // MARK: - Public properties
    
    weak var notificationCellDelegate: NotificationCellDelegate?
    
    // MARK: - Private properties
    
    @UsesAutoLayout
    private var timeCellView = TimeCellView()
    
    @UsesAutoLayout
    private var repeatCellView = RepeatCellView()
    
    // MARK: - Override methods
    
    override func setupCell() {
        selectionStyle = .none
    }
    
    // MARK: - Public methods
    
    func configure(with viewModel: NotificationSettingCellModel) {
        if viewModel.buttonName != nil {
            let selectTimeAction: ((TimeNotification) -> Void)? = { [weak self] time in
                self?.notificationCellDelegate?.didSelectTimeNotification(time: time)
            }
            
            timeCellView.configure(
                with: viewModel,
                selectTimeAction: selectTimeAction
            )
            
            setupConstraintsFor(timeCellView)
        } else {
            let toggleAction: ((Bool) -> Void)? = { [weak self] isRepeat in
                self?.notificationCellDelegate?.didToggleSwitched(isRepeat: isRepeat)
            }
            
            repeatCellView.configure(
                with: viewModel,
                toggleAction: toggleAction
            )
            
            setupConstraintsFor(repeatCellView)
        }
    }
    
    // MARK: - Private methods
    
    private func setupConstraintsFor(_ cellView: BaseView) {
        contentView.addSubview(cellView)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        layoutIfNeeded()
    }
}
