//
//  MedicinesConfigurator.swift.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

/// Конфигурация VIPER модуля
final class MedicinesConfigurator {
    
    private let notificationService: NotificationService
    private let coreDataService: ICoreDataService
    
    /// Передача текущей аптечки на экран с лекарствами
    /// - Используется для привязки лекарства к аптечке и фильтрации лекарств привязанных к
    /// аптечке
    /// - Parameter firstAidKit: принимает текущую аптечку
    init(
        notificationService: NotificationService,
        coreDataService: ICoreDataService
    ) {
        self.coreDataService = coreDataService
        self.notificationService = notificationService
    }
    
    func config(
        view: UIViewController,
        navigationController: UINavigationController?,
        currentFirstAidKit: DBFirstAidKit?
    ) {
        guard let currentFirstAidKit = currentFirstAidKit else { return }
        guard let view = view as? MedicinesViewController else { return }
        
        let presenter = MedicinesPresenter()
        let interactor = MedicinesInteractor()
        let router = MedicinesRouter(withNavigationController: navigationController)
        let fetchedResultManager = MedicinesFetchedResultsManager(
            fetchedResultsController: coreDataService.fetchResultController(
                entityName: String(describing: DBMedicine.self),
                keyForSort: #keyPath(DBMedicine.title),
                sortAscending: true,
                currentFirstAidKit: currentFirstAidKit
            )
        )
        
        view.presenter = presenter
        view.currentFirstAidKit = currentFirstAidKit
        view.fetchedResultManager = fetchedResultManager
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.notificationService = notificationService
        interactor.coreDataService = coreDataService
    }
}
