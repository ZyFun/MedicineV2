//
//  MedicineRouter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.12.2021.
//

import UIKit

protocol MedicineRoutingLogic {
    /// Метод для возврата на предыдущий экран
    func routeToBack()
}

final class MedicineRouter {
    weak var navigationController: UINavigationController?
    
    init(withNavigationController: UINavigationController?) {
        navigationController = withNavigationController
    }
}

extension MedicineRouter: MedicineRoutingLogic {
    func routeToBack() {
        navigationController?.popViewController(animated: true)
    }
}
