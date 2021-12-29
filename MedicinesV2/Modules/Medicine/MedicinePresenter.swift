//
//  MedicinePresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.12.2021.
//

import Foundation

/// Логика подготовки данных для презентации
protocol MedicinePresentationLogic: AnyObject {
    func presentData(_ data: Medicine?)
}

/// Логика получения данных
protocol MedicineViewControllerOutput {
    /// Метод для перехода к лекартсвам в аптечке, по индексу аптечки
    /// - Parameter indexPath: принимает индекс аптечки
    func routeToMedicines(by indexPath: IndexPath)
}

final class MedicinePresenter {
    weak var view: MedicineDisplayLogic?
    var interactor: MedicineBusinessLogic?
    var router: MedicineRoutingLogic?
}

extension MedicinePresenter: MedicineViewControllerOutput {
    func routeToMedicines(by indexPath: IndexPath) {
        // TODO: Доделать
    }
}

extension MedicinePresenter: MedicinePresentationLogic {
    func presentData(_ data: Medicine?) {
        // TODO: Доделать
    }
}
