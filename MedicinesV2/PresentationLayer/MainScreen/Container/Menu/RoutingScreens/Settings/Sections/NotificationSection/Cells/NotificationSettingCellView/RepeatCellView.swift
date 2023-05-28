//
//  RepeatCellView.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 25.05.2023.
//

import UIKit
import DTLogger

final class RepeatCellView: BaseView {
    
    // MARK: - Private properties
    
    private var toggleAction: ((Bool) -> Void)?
    
    @UsesAutoLayout
    private var nameSettingLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.settings(.defaultSize).font
        return label
    }()
    
    @UsesAutoLayout
    private var repeatSwitch: UISwitch = {
        let repeatSwitch = UISwitch()
        return repeatSwitch
    }()
    
    // MARK: - Override methods
    
    override func setupView() {
        backgroundColor = .secondarySystemGroupedBackground
        setupSwitch()
        setupConstraints()
    }
    
    // MARK: - Public methods
    
    func configure(with viewModel: NotificationSettingCellModel, toggleAction: ((Bool) -> Void)?) {
        self.toggleAction = toggleAction
        nameSettingLabel.text = viewModel.settingName
        repeatSwitch.setOn(viewModel.isRepeat ?? true, animated: false)
    }
    
    // MARK: - Private methods
    
    private func setupSwitch() {
        let switchToggle = UIAction { [weak self] _ in
            self?.didChangedValueSwitch()
        }
        
        repeatSwitch.addAction(switchToggle, for: .valueChanged)
    }
    
    private func didChangedValueSwitch() {
        guard let toggleAction = self.toggleAction else {
            SystemLogger.error("Действие не было передано на вью ячейки")
            return
        }
        
        if repeatSwitch.isOn {
            toggleAction(true)
        } else {
            toggleAction(false)
        }
    }
    
    private func setupConstraints() {
        addSubview(nameSettingLabel)
        addSubview(repeatSwitch)
        
        NSLayoutConstraint.activate([
            nameSettingLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: Padding.contentInCell),
            nameSettingLabel.centerYAnchor
                .constraint(equalTo: centerYAnchor),
            
            repeatSwitch.trailingAnchor
                .constraint(equalTo: trailingAnchor, constant: -Padding.contentInCell),
            repeatSwitch.centerYAnchor
                .constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - Constants

private extension RepeatCellView {
    struct Padding {
        static let contentInCell: CGFloat = 16
    }
}
