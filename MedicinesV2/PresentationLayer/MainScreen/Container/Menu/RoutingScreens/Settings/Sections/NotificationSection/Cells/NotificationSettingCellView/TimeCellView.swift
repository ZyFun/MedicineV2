//
//  NotificationCellView.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.05.2023.
//

import UIKit
import DTLogger

final class TimeCellView: BaseView {
    typealias TimeNotification = NotificationSettingCellModel.TimeNotification
    
    // MARK: - Dependencies
    
    // TODO: (MEDIC-48) Подумать как избавится от синглтона если это возможно и пробросить зависимость
    private let logger: DTLogger = DTLogger.shared
    
    // MARK: - Private properties
    
    private var selectTimeAction: ((TimeNotification) -> Void)?
    
    @UsesAutoLayout
    private var nameSettingLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.systemNormal(.defaultSize).font
        return label
    }()
    
    @UsesAutoLayout
    private var timeButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    // MARK: - Override methods
    
    override func setupView() {
        backgroundColor = .secondarySystemGroupedBackground
        setupMenuForButtons()
        setupConstraints()
    }
    
    // MARK: - Public methods
    
    func configure(with viewModel: NotificationSettingCellModel, selectTimeAction: ((TimeNotification) -> Void)?) {
        self.selectTimeAction = selectTimeAction
        nameSettingLabel.text = viewModel.settingName
        timeButton.setTitle(viewModel.buttonName?.description, for: .normal)
    }
    
    // MARK: - Private methods
    
    private func setupMenuForButtons() {
        setupTimeMenu()
    }
    
    private func setupTimeMenu() {
        let morning = UIAction(title: TimeNotification.morning.description) { [weak self] _ in
            self?.timeButton.setTitle(TimeNotification.morning.description, for: .normal)
            guard let selectTimeAction = self?.selectTimeAction else {
                self?.logger.log(.error, "Действие не было передано на вью ячейки")
                return
            }
            
            selectTimeAction(.morning)
        }
        
        let day = UIAction(title: TimeNotification.day.description) { [weak self] _ in
            self?.timeButton.setTitle(TimeNotification.day.description, for: .normal)
            
            guard let selectTimeAction = self?.selectTimeAction else {
                self?.logger.log(.error, "Действие не было передано на вью ячейки")
                return
            }
            
            selectTimeAction(.day)
        }
        
        let evening = UIAction(title: TimeNotification.evening.description) { [weak self] _ in
            self?.timeButton.setTitle(TimeNotification.evening.description, for: .normal)
            
            guard let selectTimeAction = self?.selectTimeAction else {
                self?.logger.log(.error, "Действие не было передано на вью ячейки")
                return
            }
            
            selectTimeAction(.evening)
        }
        
        let menu = UIMenu(
			title: String(localized: "Когда показать уведомления?"),
            children: [morning, day, evening]
        )
        timeButton.menu = menu
        timeButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupConstraints() {
        addSubview(nameSettingLabel)
        addSubview(timeButton)
        
        NSLayoutConstraint.activate([
            nameSettingLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: Constants.SettingCell.yPadding),
            nameSettingLabel.centerYAnchor
                .constraint(equalTo: centerYAnchor),
            
            timeButton.trailingAnchor
                .constraint(equalTo: trailingAnchor, constant: -Constants.SettingCell.yPadding),
            timeButton.centerYAnchor
                .constraint(equalTo: centerYAnchor)
        ])
    }
}
