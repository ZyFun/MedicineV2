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
    private let fetchedResultManager: IFirstAidKitsFetchedResultsManager
    private let splashPresenter: ISplashPresenter
    
    init(
        notificationManager: INotificationMedicineManager,
        coreDataService: ICoreDataService,
        splashPresenter: ISplashPresenter
    ) {
        self.notificationManager = notificationManager
        self.coreDataService = coreDataService
        self.splashPresenter = splashPresenter
        fetchedResultManager = FirstAidKitsFetchedResultsManager(
            fetchedResultsController: coreDataService.fetchResultController(
                entityName: String(describing: DBFirstAidKit.self),
                keyForSort: #keyPath(DBFirstAidKit.title),
                sortAscending: true,
                currentFirstAidKit: nil
            )
        )
    }
    
    func config(view: UIViewController, navigationController: UINavigationController) {
        guard let view = view as? FirstAidKitsViewController else {
            SystemLogger.error("ViewController аптечки не инициализирован")
            return
        }
        
        let presenter = FirstAidKitsPresenter()
        let interactor = FirstAidKitInteractor()
        let router = FirstAidKitRouter(withNavigationController: navigationController)
        let dataSourceProvider = FirstAidKitsDataSourceProvider(
            presenter: presenter,
            resultManager: fetchedResultManager
        )
        
        view.splashPresenter = splashPresenter
        view.presenter = presenter
        view.dataSourceProvider = dataSourceProvider
        view.fetchedResultManager = fetchedResultManager
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.notificationManager = notificationManager
        interactor.coreDataService = coreDataService
    }
}
