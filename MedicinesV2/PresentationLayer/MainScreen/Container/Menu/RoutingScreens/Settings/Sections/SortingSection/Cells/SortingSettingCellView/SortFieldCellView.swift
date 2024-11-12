//
//  SortFieldCellView.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 21.09.2023.
//

import UIKit
import DTLogger

/// Ячейка с выбором настройки сортировки по полю
final class SortFieldCellView: BaseView {
    typealias SortField = SortingSettingCellModel.FieldSorting
    
    // MARK: - Dependencies
    
    // TODO: (MEDIC-48) Подумать как избавится от синглтона если это возможно и пробросить зависимость
    private let logger: DTLogger = DTLogger.shared
    
    // MARK: - Private properties
    
    /// Действие, которое будет выполнено после выбора поля сортировки
    private var selectSortingAction: ((SortField) -> Void)?
    
    @UsesAutoLayout
    private var nameSettingLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.systemNormal(.defaultSize).font
        return label
    }()
    
    /// Простая кнопка, предназначенная для выбора настройки сортировки
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
    
    /// Метод для конфигурирования ячейки
    /// - Метод задаёт название настройки сортировки и устанавливает название кнопки выбранной сортировки.
    /// - Parameters:
    ///   - viewModel: принимает модель настроек ячейки
    ///   - selectSortingAction: принимает замыкание, которое будет выполняться после выбора настройки сортировки
    func configure(with viewModel: SortingSettingCellModel, selectSortingAction: ((SortField) -> Void)?) {
        self.selectSortingAction = selectSortingAction
        nameSettingLabel.text = viewModel.settingName
        
        if let ascending = viewModel.ascending {
            sortingButton.setTitle(ascending.description, for: .normal)
        }
        
        if let field = viewModel.field {
            sortingButton.setTitle(field.description, for: .normal)
        }
    }
    
    // MARK: - Private methods
    
    private func setupMenuForButtons() {
        setupButtonMenu()
    }
    
    private func setupButtonMenu() {
        let dateCreated = UIAction(title: SortField.dateCreated.description) { [weak self] _ in
            self?.sortingButton.setTitle(SortField.dateCreated.description, for: .normal)
            guard let selectAction = self?.selectSortingAction else {
                self?.logger.log(.error, "Действие не было передано на вью ячейки")
                return
            }
            
            selectAction(.dateCreated)
        }
        
        let name = UIAction(title: SortField.title.description) { [weak self] _ in
            self?.sortingButton.setTitle(SortField.title.description, for: .normal)
            guard let selectAction = self?.selectSortingAction else {
                self?.logger.log(.error, "Действие не было передано на вью ячейки")
                return
            }
            
            selectAction(.title)
        }
        
        let expiryDate = UIAction(title: SortField.expiryDate.description) { [weak self] _ in
            self?.sortingButton.setTitle(SortField.expiryDate.description, for: .normal)
            guard let selectAction = self?.selectSortingAction else {
                self?.logger.log(.error, "Действие не было передано на вью ячейки")
                return
            }
            
            selectAction(.expiryDate)
        }
        
        let menu = UIMenu(
			title: String(localized: "Поле сортировки"),
            children: [dateCreated, name, expiryDate]
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
