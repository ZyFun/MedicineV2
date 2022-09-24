//
//  MedicinePresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.12.2021.
//

import Foundation

/// Протокол логики презентации данных
protocol MedicinePresentationLogic: AnyObject {
    /// Метод для возврата в список лекарств после сохранения лекарства
    func returnToBack()
    ///  Логика отображения сообщения об ошибке
    func showError()
}

/// Протокол взаимодействия ViewController-a с презенетром
protocol MedicineViewControllerOutput {
    /// Сохранение или создание нового лекарства
    /// - Если лекарство nil, создаётся новое лекарство. Если нет, идет редактирование текущего
    /// лекарства.
    /// - После сохранения лекарства, идет возврат на предыдущий экран.
    /// - Parameters:
    ///   - name: принимает название лекарства
    ///   - type: принимает тип лекарства
    ///   - amount: принимает количество лекарств
    ///   - countSteps: принимает количество шагов степпера
    ///   - expiryDate: принимает дату срока годности
    ///   - currentFirstAidKit: принимает текущую аптечку (используется для связи лекарства
    ///   с аптечкой)
    ///   - medicine: принимает текущее лекарство
    func createMedicine(
        name: String?,
        type: String?,
        amount: String?,
        countSteps: String?,
        expiryDate: String?,
        currentFirstAidKit: DBFirstAidKit?,
        medicine: DBMedicine?
    )
}

final class MedicinePresenter {
    weak var view: MedicineDisplayLogic?
    var interactor: MedicineBusinessLogic?
    var router: MedicineRoutingLogic?
}

extension MedicinePresenter: MedicineViewControllerOutput {
    func createMedicine(
        name: String?,
        type: String?,
        amount: String?,
        countSteps: String?,
        expiryDate: String?,
        currentFirstAidKit: DBFirstAidKit?,
        medicine: DBMedicine?
    ) {
        interactor?.createMedicine(
            name: name,
            type: type,
            amount: amount,
            countSteps: countSteps,
            expiryDate: expiryDate,
            currentFirstAidKit: currentFirstAidKit,
            dbMedicine: medicine
        )
    }
}

extension MedicinePresenter: MedicinePresentationLogic {
    func showError() {
        view?.showErrorAlert(errorMessage: .noNameMedicine)
    }
    
    func returnToBack() {
        router?.routeToBack()
    }
}
