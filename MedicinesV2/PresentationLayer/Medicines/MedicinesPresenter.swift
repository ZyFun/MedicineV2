//
//  MedicinesPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

/// Протокол логики презентации данных
protocol MedicinesPresentationLogiс: AnyObject {
    /// Логика передачи подготовленных данных на экран
    /// - Parameter data: принимает массив лекарств
    func presentData(_ data: [Medicine]?)
}

/// Протокол взаимодействия ViewController-a с презенетром
protocol MedicinesViewControllerOutput {
    /// Метод для получения лекарств при первой загрузке и обновлении/добавлении данных
    func requestData()
    
    /// Метод для удаления данных из БД
    /// - Parameter medicine: принимает лекарство, которое необходимо удалить из БД
    func deleteData(_ medicine: Medicine)
    
    /// Метод для перехода к конкретному лекарству, или созданию нового
    /// с передачей текущей аптечки, для привязки лекарства к ней.
    /// - Parameters:
    ///   - currentFirstAidKit: принимает текущую аптечку, для привязки к ней лекарства
    ///   - currentMedicine: принимает текущее лекарство, для его редактирования.
    ///   Если оно nil, то будет создано новое лекарство
    func routeToMedicine(with currentFirstAidKit: FirstAidKit?, by currentMedicine: Medicine?)
}

final class MedicinesPresenter {
    
    weak var view: DisplayLogic?
    var interactor: MedicinesBusinessLogic?
    var router: MedicinesRouter?
}

extension MedicinesPresenter: MedicinesViewControllerOutput {
    func requestData() {
        interactor?.requestData()
    }
    
    func deleteData(_ medicine: Medicine) {
        interactor?.deleteData(medicine: medicine)
    }
    
    func routeToMedicine(with currentFirstAidKit: FirstAidKit?, by currentMedicine: Medicine?) {
        router?.routeTo(target: .medicine(currentFirstAidKit, currentMedicine))
    }
}

extension MedicinesPresenter: MedicinesPresentationLogiс {
    func presentData(_ data: [Medicine]?) {
        guard let viewModels = data.map({ $0 }) else { return }
        view?.display(viewModels)
    }
}
