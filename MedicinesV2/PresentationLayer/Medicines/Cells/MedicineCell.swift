//
//  MedicineCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 03.10.2023.
//

import UIKit
import DTLogger

/// Ячейка для лекарства
final class MedicineCell: UITableViewCell, IdentifiableCell {
    
    /// Замыкание, которое срабатывает после нажатия на кнопку ``pressedEditButton``
    /// - Нужно для того, чтобы перейти на следующий экран редактирования лекарства.
    var buttonTappedAction: (() -> Void)?
    
    // MARK: - Private properties

    private let containerVStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.axis = .vertical
        view.spacing = Indents.edgeMarginPadding
        view.layer.cornerRadius = 30
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(
            top: Indents.edgeMarginPadding,
            left: Indents.edgeMarginPadding,
            bottom: Indents.edgeMarginPadding,
            right: Indents.edgeMarginPadding
        )
        return view
    }()
    
    private let titleContentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.systemNormal(.size1).font
        label.numberOfLines = 2
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = Constants.iconMedecineSize / 2
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let separatorTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.systemNormal(.size2).font
        label.textColor = .systemGray
        label.numberOfLines = 2
        return label
    }()
    
    private let calculableContentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .top
        view.distribution = .fillEqually
        return view
    }()
    
    private let amountContentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = Indents.elementsPadding
        return view
    }()
    
    private let staticAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "Остаталось")
        label.font = Fonts.systemNormal(.size3).font
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.systemNormal(.size2).font
        return label
    }()
    
    private let expiryDateContentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .trailing
        view.spacing = Indents.elementsPadding
        return view
    }()
    
    private let staticExpiryDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "Срок годности")
        label.font = Fonts.systemNormal(.size3).font
        return label
    }()
    
    private let expiryDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.systemNormal(.size2).font
        return label
    }()
    
    private let separatorBottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let bottomContentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        return view
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
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String(localized: "Редактировать"), for: .normal)
        button.titleLabel?.font = Fonts.systemNormal(.size2).font
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.darkCyan
        button.layer.cornerRadius = 15
        button.accessibilityLabel = "Open Button"
        
        let tapAction = UIAction(title: "tap action") { [weak self] _ in
            self?.pressedEditButton()
        }
        
        button.addAction(tapAction, for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        iconImageView.image = nil
        descriptionLabel.isHidden = false
        descriptionLabel.text = ""
        amountLabel.text = ""
        expiryDateLabel.text = ""
        
        setImageActionIconDefault()
    }
    
    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setupCardShadowColor()
    }
    
    // MARK: - Actions
    
    private func pressedEditButton() {
        buttonTappedAction?()
    }
}

// MARK: - Public methods

extension MedicineCell {
    func configure(
        image: String? = nil,
        name: String,
        type: String?,
        purpose: String?,
        expiryDate: Date?,
        amount: NSNumber?
    ) {
        setImage(from: image)
        nameLabel.text = name
        
        let description = generateDescriptionFrom(type, purpose)
        descriptionLabel.text = description
        
        amountLabel.text = "\(amount ?? 0) шт"
        
        if let expiryDate {
            expiryDateLabel.text = expiryDate.toString()
        } else {
            expiryDateLabel.text = String(localized: "Не задано")
            expiryDateLabel.textColor = Colors.pinkRed
        }
                
        if description == "" {
            descriptionLabel.isHidden = true
        }
        
        if let expiryDate, Date() >= expiryDate {
            setImageActionIcon(need: .thrownOut)
        } else if amount?.doubleValue ?? 0 <= 0 {
            setImageActionIcon(need: .buy)
        }
    }
    
    // TODO: (Следующий спринт) Будет добавлена установка изображений. 
    // Пока думаю, брать из сети, или давать это делать пользователю.
    // Либо встроить иконки в приложение
    private func setImage(from url: String?) {
        iconImageView.image = SystemIcons.pills.image
        iconImageView.tintColor = Colors.lightGreen
    }
    
    /// Настройка иконки предупреждения
    /// - Parameter need: принимает действие, которое нужно произвести с лекарством
    /// пользователю
    private func setImageActionIcon(need: ActionWithMedicine) {
        switch need {
        case .buy:
            actionIcon.image = SystemIcons.cart.image
            actionIcon.tintColor = Colors.lightGreen
            amountLabel.textColor = Colors.pinkRed
        case .thrownOut:
            actionIcon.image = SystemIcons.deleteIcon.image
            actionIcon.tintColor = Colors.pinkRed
            expiryDateLabel.textColor = Colors.pinkRed
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
}

// MARK: - Configuration methods

private extension MedicineCell {
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        setupCardShadow()
    }
    
    /// Метод настройки параметров тени карточки
    func setupCardShadow() {
        setupCardShadowColor()
        containerVStackView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerVStackView.layer.shadowRadius = 5
        containerVStackView.layer.shadowOpacity = 0.3
    }
    
    /// Используется для изменения цвета тени карточки лекарства
    /// - Вынес в отдельный метод, потому что при смене темного и светлого режима
    /// нужно вызывать в traitCollectionDidChange для изменение цвета. Так как cgColor
    /// не изменяются сами.
    func setupCardShadowColor() {
        containerVStackView.layer.shadowColor = Colors.cardShadow.cgColor
    }
    
    func addViews() {
        contentView.addSubview(containerVStackView)
        
        containerVStackView.addArrangedSubview(titleContentStackView)
        titleContentStackView.addArrangedSubview(nameLabel)
        titleContentStackView.addArrangedSubview(iconImageView)
        
        containerVStackView.setCustomSpacing(Indents.elementsPadding, after: titleContentStackView)
        containerVStackView.addArrangedSubview(separatorTopView)
        
        containerVStackView.addArrangedSubview(descriptionLabel)
        
        containerVStackView.addArrangedSubview(calculableContentStackView)
        calculableContentStackView.addArrangedSubview(amountContentStackView)
        amountContentStackView.addArrangedSubview(staticAmountLabel)
        amountContentStackView.addArrangedSubview(amountLabel)
        
        calculableContentStackView.addArrangedSubview(expiryDateContentStackView)
        expiryDateContentStackView.addArrangedSubview(staticExpiryDateLabel)
        expiryDateContentStackView.addArrangedSubview(expiryDateLabel)
        
        containerVStackView.setCustomSpacing(Indents.elementsPadding, after: calculableContentStackView)
        containerVStackView.addArrangedSubview(separatorBottomView)
        
        containerVStackView.setCustomSpacing(Indents.elementsPadding, after: separatorBottomView)
        containerVStackView.addArrangedSubview(bottomContentStackView)
        bottomContentStackView.addArrangedSubview(actionIcon)
        bottomContentStackView.addArrangedSubview(editButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerVStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Indents.edgeMarginPadding),
            containerVStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Indents.edgeMarginPadding),
            containerVStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Indents.edgeMarginPadding),
            containerVStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Indents.edgeMarginPadding),
                        
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconMedecineSize),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.iconMedecineSize),
            
            separatorTopView.heightAnchor.constraint(equalToConstant: Constants.heightBorder),
            separatorBottomView.heightAnchor.constraint(equalToConstant: Constants.heightBorder),
            
            actionIcon.widthAnchor.constraint(equalToConstant: Constants.iconActionSize),
            
            editButton.heightAnchor.constraint(equalToConstant: Constants.editButtonHeight),
            editButton.widthAnchor.constraint(equalToConstant: Constants.editBottonWidth)
        ])
    }
}

private extension MedicineCell {
    struct Constants {
        static let iconMedecineSize: CGFloat = 48
        static let iconActionSize: CGFloat = 28
        static let heightBorder: CGFloat = 2
        static let editButtonHeight: CGFloat = 50
        static let editBottonWidth: CGFloat = UIScreen.main.bounds.width * 0.4139 // примерно 178
    }
}
