//
//  FirstAidKitsPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import Foundation
import CoreData

/// Логика подготовки данных для презентации
protocol FirstAidKitsPresentationLogic: AnyObject {
    func presentData(_ data: FirstAidKit?)
}

/// Логика получения данных
protocol FirstAidKitsViewControllerOutput {
    /// Временный метод для получения аптечек при первой загрузке
    func requestData() -> NSFetchedResultsController<NSFetchRequestResult>
    
    /// Метод для перехода к лекартсвам в аптечке, по индексу аптечки
    /// - Parameter indexPath: принимает индекс аптечки
    func routeToMedicines(by indexPath: IndexPath)
}

final class FirstAidKitsPresenter {
    weak var view: FirstAidKitsDisplayLogic?
    var interactor: FirstAidKitsBusinessLogic?
    var router: FirstAidKitRoutingLogic?
}

extension FirstAidKitsPresenter: FirstAidKitsViewControllerOutput {
    /// Временный метод для получения аптечек при первой загрузке
    func requestData() -> NSFetchedResultsController<NSFetchRequestResult> {
        (interactor?.requestData())!
    }
    
    /// Метод для перехода к лекартсвам в аптечке, по индексу аптечки
    /// - Parameter indexPath: принимает индекс аптечки
    func routeToMedicines(by indexPath: IndexPath) {
        if let object = interactor?.requestData(at: indexPath) {
            router?.routeTo(target: .medicines(object))
        }
    }
}

extension FirstAidKitsPresenter: FirstAidKitsPresentationLogic {
    func presentData(_ data: FirstAidKit?) {
        view?.display(data)
    }
}
