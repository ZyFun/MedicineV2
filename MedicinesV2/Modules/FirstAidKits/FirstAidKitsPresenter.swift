//
//  FirstAidKitsPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import Foundation

/// Протокол логики презентации данных
protocol FirstAidKitsPresentationLogic: AnyObject {
    /// Логика передачи подготовленных данных на экран
    /// - Parameter data: принимает массив аптечек
    func presentData(_ data: [FirstAidKit]?)
}

/// Протокол взаимодействия ViewController-a с презенетром
protocol FirstAidKitsViewControllerOutput {
    
    /// Метод для создания новой аптечки
    /// - Parameter firstAidKitName: принимает пользовательское имя аптечки
    func createData(_ firstAidKitName: String)
    
    /// Метод для получения аптечек при первой загрузке и обновлении/добавлении данных
    func requestData()
    
    /// Метод для редактирования аптечки
    /// - Parameters:
    ///   - firstAidKit: принимает аптечку, которую необходимо отредактировать
    ///   - newName: принимает новое пользовательское имя для аптечки
    func updateData(_ firstAidKit: FirstAidKit, newName: String)
    
    /// Метод для удаления данных из БД
    /// - Parameter firstAidKit: принимает аптечку, которую необходимо удалить из БД
    func deleteData(_ firstAidKit: FirstAidKit)
    
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
    // MARK: CRUD methods
    func createData(_ firstAidKitName: String) {
        interactor?.createData(firstAidKitName)
    }
    
    func requestData(){
        interactor?.requestData()
    }
    
    func updateData(_ firstAidKit: FirstAidKit, newName: String) {
        interactor?.updateData(firstAidKit, newName: newName)
    }
    
    func deleteData(_ firstAidKit: FirstAidKit) {
        interactor?.deleteData(firstAidKit: firstAidKit)
    }
    
    // MARK: Routing
    func routeToMedicines(by indexPath: IndexPath) {
        if let object = interactor?.requestData(at: indexPath) {
            router?.routeTo(target: .medicines(object))
        }
    }
}

extension FirstAidKitsPresenter: FirstAidKitsPresentationLogic {
    func presentData(_ data: [FirstAidKit]?) {
        view?.display(data)
    }
}
