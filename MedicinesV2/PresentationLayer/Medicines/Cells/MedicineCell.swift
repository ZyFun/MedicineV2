//
//  MedicineCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.10.2022.
//

import UIKit

/// Ячейка для лекарства
final class MedicineCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static let identifier = String(describing: MedicineCell.self)
    
    // MARK: - Private properties
    
    /// Кастомный контейнер
    /// - В нем содержаться все элементы лекарства
    /// - нужен для того, чтобы сделать его в виде карточки
    private let viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        return view
    }()
    
    /// Стек лейблов
    /// - Предназначен для: названия лекарства, типа лекарства, назначения, срока годности
    private var stackMedicineLabels: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 4
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textColor = .systemGray3
        label.numberOfLines = 2
        return label
    }()
    
    private let expiryDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    /// Иконка действия
    /// - показывает иконку, что необходимо сделать с лекарством:
    ///     - Выбросить
    ///     - Купить
    private let actionIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        
        contentView.addSubview(viewContainer)
        viewContainer.addSubview(stackMedicineLabels)
        stackMedicineLabels.addArrangedSubview(nameLabel)
        stackMedicineLabels.addArrangedSubview(descriptionLabel)
        stackMedicineLabels.addArrangedSubview(expiryDateLabel)
        viewContainer.addSubview(actionIcon)
        viewContainer.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            viewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            viewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            stackMedicineLabels.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 8),
            stackMedicineLabels.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 16),
            stackMedicineLabels.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -8),
            
            actionIcon.widthAnchor.constraint(equalToConstant: 25),
            actionIcon.heightAnchor.constraint(equalToConstant: 25),
            actionIcon.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 8),
            actionIcon.leadingAnchor.constraint(equalTo: stackMedicineLabels.trailingAnchor, constant: 8),
            actionIcon.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -16),
            actionIcon.bottomAnchor.constraint(lessThanOrEqualTo: amountLabel.topAnchor, constant: -25),
            
            amountLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -16),
            amountLabel.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    
    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setupCardShadowColor()
    }
    
    // MARK: - Public method
    
    /// Настройка информации, которая будет отображаться в ячейке лекарства
    /// - Parameters:
    ///   - name: принимает название лекарства
    ///   - type: принимает тип лекарства
    ///   - expiryDate: принимает дату срока годности лекарства
    ///   - amount: принимает количество оставшегося лекарства
    func configure (
        name: String,
        type: String?,
        purpose: String?,
        expiryDate: Date?,
        amount: NSNumber?
    ) {
        let description = generateDescriptionFrom(type, purpose)
        
        nameLabel.text = name
        descriptionLabel.text = description
        expiryDateLabel.text = expiryDate?.toString()
        amountLabel.text = "\(amount ?? 0) шт"
        
        setImageActionIconDefault()
        
        if let expiryDate, Date() >= expiryDate {
            setImageActionIcon(need: .thrownOut)
        } else if amount?.doubleValue ?? 0 <= 0 {
            setImageActionIcon(need: .buy)
        }
    }
    
    // MARK: - Private method
    
    /// Метод генерации описания лекарсва из типа и назначения
    /// - Parameters:
    ///   - type: принимает тип лекарства.
    ///   - purpose: принимает назначение (область применения) лекарства.
    /// - Returns: возвращает сгенерированное описание.
    /// - Используется для правильной генерации строки описания, с запятыми и пробелами
    private func generateDescriptionFrom(_ type: String?, _ purpose: String?) -> String? {
        if let type, type != "", let purpose, purpose != "" {
            return "\(type), \(purpose)"
        } else if let type, type != "" {
            return type
        } else if let purpose {
            return purpose
        } else {
            return nil
        }
    }
    
    /// Настройка иконки предупреждения
    /// - Parameter need: принимает действие, которое нужно произвести с лекарством
    /// пользователю
    private func setImageActionIcon(need: ActionWithMedicine) {
        switch need {
        case .buy:
            actionIcon.image = UIImage(systemName: "cart")
            actionIcon.tintColor = #colorLiteral(red: 0.4078431373, green: 0.8156862745, blue: 0.6823529412, alpha: 1)
            amountLabel.textColor = #colorLiteral(red: 0.8729341626, green: 0.4694843888, blue: 0.5979845524, alpha: 1)
        case .thrownOut:
            actionIcon.image = UIImage(systemName: "trash")
            actionIcon.tintColor = #colorLiteral(red: 0.8729341626, green: 0.4694843888, blue: 0.5979845524, alpha: 1)
            expiryDateLabel.textColor = #colorLiteral(red: 0.8729341626, green: 0.4694843888, blue: 0.5979845524, alpha: 1)
        }
    }
    
    /// Метод для сброса иконки предупреждения
    /// - используется для сброса расцветки лейблов и иконки в случае их изменения, а так же при
    /// переиспользовании ячеек, к примеру в процессе поиска.
    private func setImageActionIconDefault() {
        actionIcon.image = nil
        expiryDateLabel.textColor = .label
        amountLabel.textColor = .label
    }
}

// MARK: - Конфигурирование ячейки

private extension MedicineCell {

    /// Метод инициализации настроек ячейки
    func setup() {
        setupUI()
    }
    
    /// Метод для настройки отображения элементов
    func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        setupCardShadow()
    }
    
    /// Метод настройки параметров тени карточки
    func setupCardShadow() {
        setupCardShadowColor()
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 3)
        viewContainer.layer.shadowRadius = 3
        viewContainer.layer.shadowOpacity = 0.5
    }
    
    /// Используется для изменения цвета тени карточки лекарства
    /// - Вынес в отдельный метод, потому что при смене темного и светлого режима
    /// нужно вызывать только изменение цвета. В дальнейшем настройка цвета
    /// будет вынесена в отдельный менеджер тем.
    func setupCardShadowColor() {
        #warning("добавить настройку тем в отдельном классе вместо хардкода текстом")
        // Используется кастомная настройка цвета, для более гармоничного цвета
        // в темном режиме. Цвет взят из Assets.
        viewContainer.layer.shadowColor = UIColor(named: "cardShadowColor")?.cgColor
    }
}
