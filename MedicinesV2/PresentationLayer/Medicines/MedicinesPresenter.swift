//
//  MedicinesPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

/// Протокол логики презентации данных
protocol MedicinesPresentationLogiс: AnyObject {
    
}

/// Протокол взаимодействия ViewController-a с презенетром
protocol MedicinesViewControllerOutput {
    /// Метод для получения лекарств при первой загрузке и обновлении/добавлении данных
    func requestData()
    /// Метод для удаления данных из БД
    /// - Parameter medicine: принимает лекарство, которое необходимо удалить из БД
    func delete(_ medicine: DBMedicine)
    /// Метод для перехода к конкретному лекарству, или созданию нового
    /// с передачей текущей аптечки, для привязки лекарства к ней.
    /// - Parameters:
    ///   - currentFirstAidKit: принимает текущую аптечку, для привязки к ней лекарства
    ///   - currentMedicine: принимает текущее лекарство, для его редактирования.
    ///   Если оно nil, то будет создано новое лекарство
    func routeToMedicine(with currentFirstAidKit: DBFirstAidKit?, by currentMedicine: DBMedicine?)
}

final class MedicinesPresenter {
    
    weak var view: MedicinesDisplayLogic?
    var interactor: MedicinesBusinessLogic?
    var router: MedicinesRouter?
}

extension MedicinesPresenter: MedicinesViewControllerOutput {
    func requestData() {
        interactor?.requestData()
    }
    
    func delete(_ medicine: DBMedicine) {
        interactor?.delete(medicine: medicine)
    }
    
    func routeToMedicine(with currentFirstAidKit: DBFirstAidKit?, by currentMedicine: DBMedicine?) {
        router?.routeTo(target: .medicine(currentFirstAidKit, currentMedicine))
    }
}

extension MedicinesPresenter: MedicinesPresentationLogiс {
    
}
