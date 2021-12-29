//
//  MedicineConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.12.2021.
//

import UIKit

/// Конфигурация VIPER модуля
final class MedicineConfigurator {
    private let firstAidKit: FirstAidKit?
    private let medicine: Medicine?

    init(firstAidKit: FirstAidKit?, medicine: Medicine?) {
        self.firstAidKit = firstAidKit
        self.medicine = medicine
    }
    
    func config(view: UIViewController, navigationController: UINavigationController?) {
        guard let view = view as? MedicineViewController else { return }
        
        view.currentFirstAidKit = firstAidKit
        view.medicine = medicine
        
        let presenter = MedicinePresenter()
        let interactor = MedicineInteractor()
        let router = MedicineRouter(withNavigationController: navigationController)
        
        view.preseter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
    }
}
