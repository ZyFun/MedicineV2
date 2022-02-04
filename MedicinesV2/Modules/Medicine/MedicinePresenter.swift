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
    /// Метод для сохранения всех изменений в БД
    /// c переходом на предыдущий экран после  сохранения.
    func saveMedicine()
}

final class MedicinePresenter {
    weak var view: MedicineDisplayLogic?
    var interactor: MedicineBusinessLogic?
    var router: MedicineRoutingLogic?
}

extension MedicinePresenter: MedicineViewControllerOutput {
    func saveMedicine() {
        interactor?.saveMedicine()
        router?.routeToBack()
    }
}

extension MedicinePresenter: MedicinePresentationLogic {
    
    func presentData(_ data: Medicine?) {
        // TODO: Доделать
    }
}
