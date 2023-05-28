//
//  BaseView.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.05.2023.
//

import UIKit

/// Абстрактный класс для вью
class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {}
}
