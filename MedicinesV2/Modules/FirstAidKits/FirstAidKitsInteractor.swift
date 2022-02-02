//
//  FirstAidKitsInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import Foundation

protocol FirstAidKitsBusinessLogic {
    
    /// Метод для перехода к лекартсвам в аптечке, по индексу аптечки
    /// - Parameter indexPath: принимает индекс аптечки
    func requestData(at indexPath: IndexPath) -> FirstAidKit?
    
    /// Метод для получения объектов из базы данных в виде массива
    func requestData()
}

final class FirstAidKitInteractor {
    weak var presenter: FirstAidKitsPresentationLogic?
    
    var data: [FirstAidKit]?
}

extension FirstAidKitInteractor: FirstAidKitsBusinessLogic {
    func requestData() {
        // TODO:  Не уверен что запись получения данных правильная. Имею в виду обращение к синглтону из интерактора.
        data = StorageManager.shared.fetchRequest(String(describing: FirstAidKit.self)) as? [FirstAidKit]
        presenter?.presentData(data)
    }
    
    func requestData(at indexPath: IndexPath) -> FirstAidKit? {
        // Так как data инициализируется и заполняется еще при создании аптечки,
        // повторно запрос к базе данных получать не нужно.
        // Но по хорошему нужен прямой запрос к нужному объекту в базе
        data?[indexPath.row]
    }
}
