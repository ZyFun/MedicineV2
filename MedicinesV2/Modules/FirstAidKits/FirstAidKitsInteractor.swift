//
//  FirstAidKitsInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

// TODO: Я не уверен что интерактор должен на прямую обращаться к синглтону БД нужно будет уточнить это у более опытных разработчиков

import Foundation

protocol FirstAidKitsBusinessLogic {
    /// Метод для создания новой аптечки.
    /// - Метод запрашивает обновленные данные из БД для обновления массива data
    /// и отправляет его в презентер, чтобы на вью обновилась модель данных,
    /// для корректной работы после создания аптечки в БД.
    /// - В запросе на создание новой аптечки должен присутствовать метод на обновление tableView.
    /// - Parameter firstAidKit: принимает имя аптечки.
    func createData(_ firstAidKitName: String)
    
    /// Метод для перехода к лекартсвам в аптечке, по индексу аптечки.
    /// - Parameter indexPath: принимает индекс аптечки
    func requestData(at indexPath: IndexPath) -> FirstAidKit?
    
    /// Метод для получения объектов из БД в виде массива.
    /// - Запрос должен происходить при первичной загрузке приложения,
    /// и при создании или удалении данных (для корректной работы с массивом в таблице)
    func requestData()
    
    /// Метод для редактирования аптечки
    /// - Parameters:
    ///   - firstAidKit: принимает аптечку, которую необходимо отредактировать
    ///   - newName: принимает новое имя для аптечки
    func updateData(_ firstAidKit: FirstAidKit, newName: String)
    
    /// Метод для удаления данных из БД
    /// - Метод запрашивает обновленные данные из БД для обновления массива data
    /// и отправляет их в презентер, чтобы на вью обновилась модель данных,
    /// для корректной работы после удаления из БД.
    /// - В запросе на удаление аптечки должен присутствовать метод на обновление tableView
    /// - Parameter firstAidKit: принимает аптечку, которую необходимо удалить из БД
    func deleteData(firstAidKit: FirstAidKit)
}

final class FirstAidKitInteractor {
    /// Ссылка на презентер
    weak var presenter: FirstAidKitsPresentationLogic?
    
    /// Данные с массивом аптечек.
    ///  - Используется для того, чтобы хранить в себе текущие данные после запроса к базе
    ///  данных, и уменьшить количество обращений к базе.
    private var data: [FirstAidKit]?
}

extension FirstAidKitInteractor: FirstAidKitsBusinessLogic {
    func deleteData(firstAidKit: FirstAidKit) {
        StorageManager.shared.deleteObject(firstAidKit)
        requestData()
    }
    
    func createData(_ firstAidKitName: String) {
        StorageManager.shared.createData(firstAidKitName)
        requestData()
    }

    func updateData(_ firstAidKit: FirstAidKit, newName: String) {
        StorageManager.shared.updateData(firstAidKit, newName: newName)
    }
    
    func requestData() {
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
