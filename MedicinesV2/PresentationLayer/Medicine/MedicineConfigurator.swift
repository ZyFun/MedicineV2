//
//  MedicineConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.12.2021.
//

import UIKit

/// Конфигурация VIPER модуля
final class MedicineConfigurator {
    
    private let notificationManager: INotificationMedicineManager
    private let coreDataService: ICoreDataService
    
    /// Передача текущей аптечки и лекарства на экран с лекарством
    /// - Аптечка используется для привязки лекарства к аптечке.
    /// - Если лекарство nil, срабатывает логика для создания нового лекарства
    /// - Parameters:
    ///   - firstAidKit: принимает текущую аптечку в которой хранится выбранное лекарство
    ///   - medicine: принимает текущее лекарство
    init(
        notificationManager: INotificationMedicineManager,
        coreDataService: ICoreDataService
    ) {
        self.notificationManager = notificationManager
        self.coreDataService = coreDataService
    }
    
    func config(
        view: UIViewController,
        navigationController: UINavigationController?,
        firstAidKit: DBFirstAidKit?,
        medicine: DBMedicine?
    ) {
        /// Свойство для передачи аптечки на экран лекарства, используется для привяки лекарства
        /// к аптечке.
        let firstAidKit = firstAidKit
        /// Свойство для текущего лекарства на экран лекарств. Если лекарство nil,
        /// срабатывает логика для создание нового лекарства.
        let medicine = medicine
        
        guard let view = view as? MedicineViewController else { return }
        
        let presenter = MedicinePresenter()
        let interactor = MedicineInteractor()
        let router = MedicineRouter(withNavigationController: navigationController)
        
        view.presenter = presenter
        view.currentFirstAidKit = firstAidKit
        view.medicine = medicine
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.notificationManager = notificationManager
        interactor.coreDataService = coreDataService
    }
}
