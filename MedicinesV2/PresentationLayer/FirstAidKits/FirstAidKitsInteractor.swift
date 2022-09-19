//
//  FirstAidKitsInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

// TODO: Я не уверен что интерактор должен на прямую обращаться к синглтону БД нужно будет уточнить это у более опытных разработчиков

import Foundation

/// Протокол для работы с бизнес логикой модуля
protocol FirstAidKitsBusinessLogic {
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
    func delete(firstAidKit: DBFirstAidKit)
}

final class FirstAidKitInteractor {
    /// Ссылка на презентер
    weak var presenter: FirstAidKitsPresentationLogic?
    var coreDataService: ICoreDataService?
    var fetchedResultManager: IFirstAidKitsFetchedResultsManager?
}

extension FirstAidKitInteractor: FirstAidKitsBusinessLogic {
    
    func createData(_ firstAidKitName: String) {
        coreDataService?.performSave({ [weak self] context in
            self?.coreDataService?.createFirstAidKit(firstAidKitName, context: context)
        })
    }

    func updateData(_ firstAidKit: DBFirstAidKit, newName: String) {
        coreDataService?.performSave({ context in
            self.coreDataService?.updateFirstAidKit(firstAidKit, newName: newName, context: context)
        })
    }
    
    func delete(firstAidKit: DBFirstAidKit) {
        coreDataService?.performSave { [weak self] context in
            self?.coreDataService?.delete(firstAidKit, context: context)
        }
    }
}
