//
//  MenuCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.01.2023.
//

import UIKit

final class MenuCell: UITableViewCell, IdentifiableCell {
    
    // MARK: - properties
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        setup()
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Publik Methods

extension MenuCell {
    
    /// Метод для конфигурирования отображаемой информации в ячейке.
    /// - Parameters:
    ///   - iconImage: принимает изображение для иконки меню
    ///   - title: принимает название пункта меню
    func configure(iconImage: UIImage, title: String) {
        iconImageView.image = iconImage
        titleLabel.text = title
    }
    
}

// MARK: - Конфигурирование ячейки

private extension MenuCell {
    
    /// Метод инициализации настроек ячейки
    func setup() {
        setupUI()
    }
    
    /// Метод для настройки отображения элементов
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
}
