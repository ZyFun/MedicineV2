//
//  MedicinesConfigurator.swift.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit
import DTLogger

/// Конфигурация VIPER модуля
final class MedicinesConfigurator {
    
    private let notificationManager: INotificationMedicineManager
    private let coreDataService: ICoreDataService
    private let sortingService: SortableSettings
    private let logger: DTLogger
    
    init(
        notificationManager: INotificationMedicineManager,
        coreDataService: ICoreDataService,
        sortingService: SortableSettings,
        logger: DTLogger
    ) {
        self.coreDataService = coreDataService
        self.notificationManager = notificationManager
        self.sortingService = sortingService
        self.logger = logger
    }
    
    /// Конфигурирование модуля
    /// - Parameters:
    ///   - view: <#view description#>
    ///   - navigationController: <#navigationController description#>
    ///   - currentFirstAidKit: принимает текущую аптечку. Используется для привязки
    ///    лекарства к аптечке.
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
                keyForSort: sortingService.getSortField(),
                sortAscending: sortingService.getSortAscending(),
                currentFirstAidKit: currentFirstAidKit
            ),
            logger: logger
        )
        let dataSourceProvider = MedicinesDataSourceProvider(
            presenter: presenter,
            resultManager: fetchedResultManager,
            currentFirstAidKit: currentFirstAidKit,
            logger: logger
        )
        
        view.presenter = presenter
        view.logger = logger
        view.currentFirstAidKit = currentFirstAidKit
        view.dataSourceProvider = dataSourceProvider
        view.fetchedResultManager = fetchedResultManager
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.notificationManager = notificationManager
        interactor.coreDataService = coreDataService
        interactor.currentFirstAidKit = currentFirstAidKit
    }
}
