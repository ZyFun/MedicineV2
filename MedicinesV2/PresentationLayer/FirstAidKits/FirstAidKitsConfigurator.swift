//
//  FirstAidKitsConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import UIKit

final class FirstAidKitsConfigurator {
    
    private let notificationService: INotificationService
    private let coreDataService: ICoreDataService
    private let fetchedResultManager: IFirstAidKitsFetchedResultsManager
    
    init(
        notificationService: INotificationService,
        coreDataService: ICoreDataService
    ) {
        self.notificationService = notificationService
        self.coreDataService = coreDataService
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
            CustomLogger.error("ViewController аптечки не инициализирован")
            return
        }
        
        let presenter = FirstAidKitsPresenter()
        let interactor = FirstAidKitInteractor()
        let router = FirstAidKitRouter(withNavigationController: navigationController)
        let dataSourceProvider = FirstAidKitsDataSourceProvider(
            presenter: presenter,
            resultManager: fetchedResultManager
        )
        
        view.presenter = presenter
        view.dataSourceProvider = dataSourceProvider
        view.fetchedResultManager = fetchedResultManager
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.notificationService = notificationService
        interactor.coreDataService = coreDataService
    }
}
