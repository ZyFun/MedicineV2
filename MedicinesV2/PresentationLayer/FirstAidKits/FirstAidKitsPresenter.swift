//
//  FirstAidKitsPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import Foundation

/// Протокол логики презентации данных
protocol FirstAidKitsPresentationLogic: AnyObject {
    
}

/// Протокол взаимодействия ViewController-a с презенетром
protocol FirstAidKitsViewControllerOutput {
    
    /// Метод для создания новой аптечки.
    /// - Parameter firstAidKit: принимает имя аптечки.
    func createData(_ firstAidKitName: String)
    /// Метод для редактирования аптечки
    /// - Parameters:
    ///   - firstAidKit: принимает аптечку, которую необходимо отредактировать
    ///   - newName: принимает новое имя для аптечки
    func updateData(_ firstAidKit: DBFirstAidKit, newName: String)
    /// Метод для удаления данных из БД
    /// - Parameter firstAidKit: принимает аптечку, которую необходимо удалить из БД
    func delete(_ firstAidKit: DBFirstAidKit)
    /// Метод для перехода к лекартсвам в выбранной аптечке.
    /// - Parameter currentFirstAidKit: принимает текущую аптечку
    func routeToMedicines(with currentFirstAidKit: DBFirstAidKit)
}

final class FirstAidKitsPresenter {
    
    weak var view: FirstAidKitsDisplayLogic?
    var interactor: FirstAidKitsBusinessLogic?
    var router: FirstAidKitRoutingLogic?
}

extension FirstAidKitsPresenter: FirstAidKitsViewControllerOutput {
    
    // MARK: - CRUD methods
    func createData(_ firstAidKitName: String) {
        interactor?.createData(firstAidKitName)
    }
    
    func updateData(_ firstAidKit: DBFirstAidKit, newName: String) {
        interactor?.updateData(firstAidKit, newName: newName)
    }
    
    func delete(_ firstAidKit: DBFirstAidKit) {
        interactor?.delete(firstAidKit: firstAidKit)
    }
    
    // MARK: - Routing
    
    func routeToMedicines(with currentFirstAidKit: DBFirstAidKit) {
        router?.routeTo(target: .medicines(currentFirstAidKit))
    }
}

extension FirstAidKitsPresenter: FirstAidKitsPresentationLogic {
    
}
