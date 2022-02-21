//
//  MedicineRouter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.12.2021.
//

import UIKit

/// Протокол логики роутера
protocol MedicineRoutingLogic {
    /// Метод для возврата на предыдущий экран
    func routeToBack()
}

final class MedicineRouter {
    private var navigationController: UINavigationController?
    
    init(withNavigationController: UINavigationController?) {
        navigationController = withNavigationController
    }
}

extension MedicineRouter: MedicineRoutingLogic {
    func routeToBack() {
        navigationController?.popViewController(animated: true)
    }
}
