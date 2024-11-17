//
//  SettingsViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 16.05.2023.
//

import UIKit
import DTLogger

/// Протокол отображения данных ViewCintroller-a
protocol SettingsView: AnyObject {
    func show(sections: [SettingSections])
}

final class SettingsViewController: UIViewController {
    
    // MARK: - Public property
    
    var presenter: SettingsPresenter?
    
    // MARK: - Dependencies
    
    var logger: DTLogger?
    
    // MARK: - Private property
    
    private var factory: SettingsFactory?
    
    @UsesAutoLayout
    private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        return tableView
    }()
    
    @UsesAutoLayout
    /// Вью для размещения кнопок
    private var bottomView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        stackView.backgroundColor = .systemGroupedBackground
        return stackView
    }()
    
    @UsesAutoLayout
    private var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Colors.darkCyan
		button.setTitle(String(localized: "Сохранить"), for: .normal)
        button.layer.cornerRadius = 16
        button.tintColor = .white
        return button
    }()
    
    @UsesAutoLayout
    private var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Colors.darkCyan
        button.setTitle(String(localized: "Отменить"), for: .normal)
        button.layer.cornerRadius = 16
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        presenter?.getSettingsSections()
    }
    
}

// MARK: - Логика обновления данных View

extension SettingsViewController: SettingsView {
    func show(sections: [SettingSections]) {
        factory?.update(sections: sections)
    }
}

// MARK: - Конфигурирование ViewController

private extension SettingsViewController {
    func setup() {
        setupButtonsAction()
        setupConstraints()
        
        factory = SettingsFactory(
            tableView: tableView,
            sections: [],
            notificationDelegate: presenter,
            sortingDelegate: presenter
        )
    }
    
    // MARK: - Actions
    
    private func setupButtonsAction() {
        let cancelButtonTapped = UIAction { [weak self] _ in
            self?.logger?.log(.info, "Выход без сохранения")
            self?.dismiss(animated: true)
        }
        
        let saveButtonTapped = UIAction { [weak self] _ in
            self?.presenter?.saveSettings()
            self?.dismiss(animated: true)
        }
        
        cancelButton.addAction(cancelButtonTapped, for: .touchUpInside)
        saveButton.addAction(saveButtonTapped, for: .touchUpInside)
    }
    
    // MARK: - Add and set UI
    
    func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(bottomView)
        bottomView.addArrangedSubview(cancelButton)
        bottomView.addArrangedSubview(saveButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.heightAnchor.constraint(equalToConstant: 104),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
