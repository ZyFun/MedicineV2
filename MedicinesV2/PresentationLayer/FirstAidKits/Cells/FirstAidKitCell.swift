//
//  FirstAidKitCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 18.10.2022.
//

import UIKit

/// Ячейка для аптечки
final class FirstAidKitCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static let identifier = String(describing: FirstAidKitCell.self)
    
    // MARK: - Private properties
    
    /// Кастомный контейнер
    /// - В нем содержаться все элементы аптечки
    /// - нужен для того, чтобы сделать его в виде карточки
    private let viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let titleFirstAidKitLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expiredMedicinesCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountMedicinesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .lightGray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        
        contentView.addSubview(viewContainer)
        viewContainer.addSubview(titleFirstAidKitLabel)
        viewContainer.addSubview(expiredMedicinesCountLabel)
        viewContainer.addSubview(amountMedicinesLabel)
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            viewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            viewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            titleFirstAidKitLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            titleFirstAidKitLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 16),
            titleFirstAidKitLabel.trailingAnchor.constraint(equalTo: amountMedicinesLabel.leadingAnchor, constant: -5),
            
            expiredMedicinesCountLabel.topAnchor.constraint(equalTo: titleFirstAidKitLabel.bottomAnchor, constant: 6),
            expiredMedicinesCountLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 16),
            expiredMedicinesCountLabel.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10),
            
            amountMedicinesLabel.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
            amountMedicinesLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Publik Methods

extension FirstAidKitCell {
    /// Метод для конфигурирования отображаемой информации в ячейке.
    /// - Parameters:
    ///   - titleFirstAidKit: принимает название аптечки.
    ///   - amountMedicines: принимает количество лекарств, хранящихся  в аптечке.
    func configure(titleFirstAidKit: String?, amountMedicines: String, expiredCount: Int) {
        self.titleFirstAidKitLabel.text = titleFirstAidKit
        self.amountMedicinesLabel.text = amountMedicines
        
        if expiredCount != 0 {
            expiredMedicinesCountLabel.text = "Просроченных лекарств: \(expiredCount)"
            expiredMedicinesCountLabel.textColor = #colorLiteral(red: 0.8729341626, green: 0.4694843888, blue: 0.5979845524, alpha: 1)
        } else {
            expiredMedicinesCountLabel.text = "Все лекарства в порядке"
            expiredMedicinesCountLabel.textColor = #colorLiteral(red: 0.4078431373, green: 0.8156862745, blue: 0.6823529412, alpha: 1)
        }
        
    }
}

// MARK: - Конфигурирование ячейки

private extension FirstAidKitCell {
    /// Метод инициализации настроек ячейки
    func setup() {
        setupUI()
    }
    
    /// Метод для настройки отображения элементов
    func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
}
