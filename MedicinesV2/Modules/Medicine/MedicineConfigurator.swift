//
//  MedicineConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.12.2021.
//

import UIKit

/// Конфигурация VIPER модуля
final class MedicineConfigurator {
    /// Свойство для передачи аптечки на экран лекарства, используется для привяки лекарства
    /// к аптечке.
    private let firstAidKit: FirstAidKit?
    /// Свойство для текущего лекарства на экран лекарств. Если лекарство nil,
    /// срабатывает логика для создание нового лекарства.
    private let medicine: Medicine?
    
    /// Передача текущей аптечки и лекарства на экран с лекарством
    /// - Аптечка используется для привязки лекарства к аптечке.
    /// - Если лекарство nil, срабатывает логика для создания нового лекарства
    /// - Parameters:
    ///   - firstAidKit: принимает текущую аптечку в которой хранится выбранное лекарство
    ///   - medicine: принимает текущее лекарство
    init(firstAidKit: FirstAidKit?, medicine: Medicine?) {
        self.firstAidKit = firstAidKit
        self.medicine = medicine
    }
    
    func config(view: UIViewController, navigationController: UINavigationController?) {
        guard let view = view as? MedicineViewController else { return }
        
        // Передача лекарства и аптечки на экран лекарства
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
