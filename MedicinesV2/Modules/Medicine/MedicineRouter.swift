//
//  MedicineRouter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.12.2021.
//

import UIKit

protocol MedicineRoutingLogic {
    // Пока что не нужно, используется только для конфигуратора
}

final class MedicineRouter {
    weak var navigationController: UINavigationController?
    
    init(withNavigationController: UINavigationController?) {
        navigationController = withNavigationController
    }
}

extension MedicineRouter: MedicineRoutingLogic {
    // Пока что не нужно, используется только для конфигуратора
}
