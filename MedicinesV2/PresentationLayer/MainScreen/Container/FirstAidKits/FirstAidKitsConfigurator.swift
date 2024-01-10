//
//  FirstAidKitsConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import UIKit
import DTLogger

final class FirstAidKitsConfigurator {
    
    private let notificationManager: INotificationMedicineManager
    private let coreDataService: ICoreDataService
	private var fetchedResultManager: IFirstAidKitsFetchedResultsManager
    private let splashPresenter: ISplashPresenter
    private let logger: DTLogger
    
    init(
        notificationManager: INotificationMedicineManager,
        coreDataService: ICoreDataService,
        splashPresenter: ISplashPresenter,
        logger: DTLogger
    ) {
        self.notificationManager = notificationManager
        self.coreDataService = coreDataService
        self.splashPresenter = splashPresenter
        self.logger = logger
        fetchedResultManager = FirstAidKitsFetchedResultsManager(
            fetchedResultsController: coreDataService.fetchResultController(
                entityName: String(describing: DBFirstAidKit.self),
                keyForSort: #keyPath(DBFirstAidKit.title),
                sortAscending: true,
                currentFirstAidKit: nil
            ),
            logger: logger
        )
    }
    
    func config(view: UIViewController, navigationController: UINavigationController) {
        guard let view = view as? FirstAidKitsViewController else {
            logger.log(.error, "ViewController аптечки не инициализирован")
            return
        }
        
        let presenter = FirstAidKitsPresenter()
        let interactor = FirstAidKitInteractor()
        let router = FirstAidKitRouter(withNavigationController: navigationController)
		// !!!: Скорее всего это нарушает архитектуру, но я не знаю как сделать по другому
		// Мне нужно обновить плейсхолдер когда данные с iCloud будут получены.
		// поэтому пришлось создать презентер у fetchedResultManager.
		fetchedResultManager.presenter = presenter
        let dataSourceProvider = FirstAidKitsDataSourceProvider(
            presenter: presenter,
            resultManager: fetchedResultManager,
            logger: logger
        )
        
        view.splashPresenter = splashPresenter
        view.presenter = presenter
        view.dataSourceProvider = dataSourceProvider
        view.fetchedResultManager = fetchedResultManager
        view.logger = logger
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.logger = logger
        interactor.notificationManager = notificationManager
        interactor.coreDataService = coreDataService
    }
}
