//
//  FirstAidKitCell.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 09.10.2023.
//

import UIKit

/// Ячейка для лекарства
final class FirstAidKitCell: UITableViewCell, IdentifiableCell {
    
    /// Замыкание, которое срабатывает после нажатия на кнопку ``pressedEditButton``
    /// - Нужно для того, чтобы перейти на следующий экран с лекарствами в аптечке.
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
        label.text = String(localized: "Лекарств в аптечке")
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
    
    private let staticExpiredAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "Просрочено")
        label.font = Fonts.systemNormal(.size3).font
        return label
    }()
    
    private let expiredAmountLabel: UILabel = {
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
    /// - показывает иконку, о необходимости обратить внимание на лекарства в аптечке:
    private let alertIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = SystemIcons.alert.image
        imageView.tintColor = Colors.pinkRed
        return imageView
    }()
    
    private lazy var openButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String(localized: "Открыть"), for: .normal)
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
        expiredAmountLabel.text = ""
        
        setAlertsDefault()
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

extension FirstAidKitCell {
    func configure(
        image: String? = nil,
        name: String,
        description: String? = nil,
        expiredAmount: Int?,
        amount: Int?
    ) {
        setImage(from: image)
        nameLabel.text = name
        
        if description == "" || description == nil {
            descriptionLabel.isHidden = true
        } else {
            descriptionLabel.text = description
        }
        
        amountLabel.text = "\(amount ?? 0) шт"
        
        expiredAmountLabel.text = "\(expiredAmount ?? 0) шт"
        if expiredAmount != 0 {
            alertIcon.isHidden = false
            expiredAmountLabel.textColor = Colors.pinkRed
        } else {
            setAlertsDefault()
        }
    }
    
    // TODO: (Задача не заведена) Будет добавлена установка изображений пользователем
    // к примеру выбор типа расположения аптечки. И соответствующая иконка
    private func setImage(from url: String?) {
        iconImageView.image = SystemIcons.firstAidKit.image
        iconImageView.tintColor = Colors.lightGreen
        iconImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
    }
    
    /// Метод для сброса всех предупреждений
    /// - используется для сброса расцветки лейблов и иконки в случае их изменения, а так же при
    /// переиспользовании ячеек, к примеру в процессе поиска.
    private func setAlertsDefault() {
        expiredAmountLabel.textColor = .label
        alertIcon.isHidden = true
    }
}

// MARK: - Configuration methods

private extension FirstAidKitCell {
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
        expiryDateContentStackView.addArrangedSubview(staticExpiredAmountLabel)
        expiryDateContentStackView.addArrangedSubview(expiredAmountLabel)
        
        containerVStackView.setCustomSpacing(Indents.elementsPadding, after: calculableContentStackView)
        containerVStackView.addArrangedSubview(separatorBottomView)
        
        containerVStackView.setCustomSpacing(Indents.elementsPadding, after: separatorBottomView)
        containerVStackView.addArrangedSubview(bottomContentStackView)
        bottomContentStackView.addArrangedSubview(alertIcon)
        bottomContentStackView.addArrangedSubview(UIView())
        bottomContentStackView.addArrangedSubview(openButton)
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
            
            alertIcon.widthAnchor.constraint(equalToConstant: Constants.iconActionSize),
            
            openButton.heightAnchor.constraint(equalToConstant: Constants.editButtonHeight),
            openButton.widthAnchor.constraint(equalToConstant: Constants.editBottonWidth)
        ])
    }
}

private extension FirstAidKitCell {
    struct Constants {
        static let iconMedecineSize: CGFloat = 48
        static let iconActionSize: CGFloat = 28
        static let heightBorder: CGFloat = 2
        static let editButtonHeight: CGFloat = 50
        static let editBottonWidth: CGFloat = UIScreen.main.bounds.width * 0.4139 // примерно 178
    }
}
