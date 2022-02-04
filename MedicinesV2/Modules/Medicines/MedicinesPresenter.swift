//
//  MedicinesPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

/// Логика подготовки данных для презентации
protocol PresentationLogiс: AnyObject {
    func presentData(_ data: [Medicine]?)
}

/// Логика получения данных
protocol MedicinesViewControllerOutput {
    func requestData()
    
    /// Метод для удаления данных из БД
    /// - Parameter medicine: принимает лекарство, которое необходимо удалить из БД
    func deleteData(_ medicine: Medicine)
    
    /// Метод для перехода к конкретному лекарству, или созданию нового
    /// с передачей текущей аптечки, для привязки лекарства к ней.
    /// - Parameters:
    ///   - currentFirstAidKit: принимает текущую аптечку, для привязки к ней лекарства
    ///   - currentMedicine: принимает текущее лекарство, для его редактирования
    func routeToMedicine(with currentFirstAidKit: FirstAidKit?, by currentMedicine: Medicine?)
}

final class MedicinesPresenter {
    
    weak var view: DisplayLogic?
    var interactor: BusinessLogic?
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

extension MedicinesPresenter: PresentationLogiс {
    func presentData(_ data: [Medicine]?) {
        guard let viewModels = data.map({ $0 }) else { return }
        view?.display(viewModels)
    }
}
