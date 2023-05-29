//
//  SortingSettingCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.05.2023.
//

import UIKit
import DTLogger

protocol SortingCellDelegate: AnyObject {
    typealias SortAscending = SortingSettingCellModel.SortAscending
    typealias SortField = SortingSettingCellModel.FieldSorting
    
    func didSelectSort(ascending: SortAscending)
    func didSelectSort(field: SortField)
}

final class SortingSettingCell: BaseTableViewCell {
    typealias SortAscending = SortingSettingCellModel.SortAscending
    typealias SortField = SortingSettingCellModel.FieldSorting
    
    // MARK: - Public properties
    
    weak var sortingCellDelegate: SortingCellDelegate?
    
    // MARK: - Private properties
    
    @UsesAutoLayout
    private var sortAscendingCellView = SortAscendingCellView()
    
    @UsesAutoLayout
    private var sortFieldCellView = SortFieldCellView()
    
    // MARK: - Override methods
    
    override func setupCell() {
        selectionStyle = .none
    }
    
    // MARK: - Public methods
    
    /// Метод конфигурирует секцию настроек сортировки
    /// - Parameter viewModel: принимает модель ячеек настройки сортировки
    func configure(with viewModel: SortingSettingCellModel) {
        // Так-как конфигурация вызывается циклом для каждой модели, сделана
        // такая реализация через if для каждой. Не оптимально, но пока лучше не придумал.
        if viewModel.ascending != nil {
            let selectSortAction: ((SortAscending) -> Void)? = { [weak self] ascending in
                self?.sortingCellDelegate?.didSelectSort(ascending: ascending)
            }
            
            sortAscendingCellView.configure(
                with: viewModel,
                selectSortingAction: selectSortAction
            )
            
            setupConstraintsFor(sortAscendingCellView)
        }
        
        if viewModel.field != nil {
            let selectSortAction: ((SortField) -> Void)? = { [weak self] field in
                self?.sortingCellDelegate?.didSelectSort(field: field)
            }
            
            sortFieldCellView.configure(
                with: viewModel,
                selectSortingAction: selectSortAction
            )
            
            setupConstraintsFor(sortFieldCellView)
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
