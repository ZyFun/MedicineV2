//
//  MedicinesPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

/// Логика подготовки данных для презентации
protocol PresentationLogik: AnyObject {
    func presentData(_ data: [Medicine]?)
}

/// Логика получения данных
protocol MedicinesViewControllerOutput {
    func requestData()
    
    // TODO: Подумать как передать нил чтобы не плодить много методов
    /// Метод для перехода к конкретному лекарству по индексу выбранного лекарства
    /// для его редактирования.
    /// - Parameter indexPath: принимает индекс лекарства
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
    
    // TODO: Подумать как передать нил чтобы не плодить много методов
    /// Метод для перехода к конкретному лекарству по индексу выбранного лекарства
    /// для его редактирования.
    /// - Parameter indexPath: принимает индекс лекарства
    func routeToMedicine(with currentFirstAidKit: FirstAidKit?, by currentMedicine: Medicine?) {
        router?.routeTo(target: .medicine(currentFirstAidKit, currentMedicine))
    }
}

extension MedicinesPresenter: PresentationLogik {
    func presentData(_ data: [Medicine]?) {
        guard let viewModels = data.map({ $0 }) else { return }
        view?.display(viewModels)
    }
}
