//
//  SortAscendingCellView.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.05.2023.
//

import UIKit
import DTLogger

final class SortAscendingCellView: BaseView {
    typealias SortAscending = SortingSettingCellModel.SortAscending
    
    // MARK: - Dependencies
    
    // TODO: (MEDIC-48) Подумать как избавится от синглтона если это возможно и пробросить зависимость
    private let logger: DTLogger = DTLogger.shared
    
    // MARK: - Private properties
    
    private var selectSortingAction: ((SortAscending) -> Void)?
    
    @UsesAutoLayout
    private var nameSettingLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.systemNormal(.defaultSize).font
        return label
    }()
    
    @UsesAutoLayout
    private var sortingButton: UIButton = {
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
    
    func configure(with viewModel: SortingSettingCellModel, selectSortingAction: ((SortAscending) -> Void)?) {
        self.selectSortingAction = selectSortingAction
        nameSettingLabel.text = viewModel.settingName
        sortingButton.setTitle(viewModel.ascending?.description, for: .normal)
    }
    
    // MARK: - Private methods
    
    private func setupMenuForButtons() {
        setupButtonMenu()
    }
    
    private func setupButtonMenu() {
        let up = UIAction(title: SortAscending.up.description) { [weak self] _ in
            self?.sortingButton.setTitle(SortAscending.up.description, for: .normal)
            guard let selectTimeAction = self?.selectSortingAction else {
                self?.logger.log(.error, "Действие не было передано на вью ячейки")
                return
            }
            
            selectTimeAction(.up)
        }
        
        let down = UIAction(title: SortAscending.down.description) { [weak self] _ in
            self?.sortingButton.setTitle(SortAscending.down.description, for: .normal)
            guard let selectTimeAction = self?.selectSortingAction else {
                self?.logger.log(.error, "Действие не было передано на вью ячейки")
                return
            }
            
            selectTimeAction(.down)
        }
        
        let menu = UIMenu(
			title: String(localized: "Направление сортировки"),
            children: [up, down]
        )
        sortingButton.menu = menu
        sortingButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupConstraints() {
        addSubview(nameSettingLabel)
        addSubview(sortingButton)
        
        NSLayoutConstraint.activate([
            nameSettingLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: Constants.SettingCell.yPadding),
            nameSettingLabel.centerYAnchor
                .constraint(equalTo: centerYAnchor),
            
            sortingButton.trailingAnchor
                .constraint(equalTo: trailingAnchor, constant: -Constants.SettingCell.yPadding),
            sortingButton.centerYAnchor
                .constraint(equalTo: centerYAnchor)
        ])
    }
}
