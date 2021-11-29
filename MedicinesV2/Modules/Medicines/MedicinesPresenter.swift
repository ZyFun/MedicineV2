//
//  MedicinesPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

/// Логика получения данных
protocol EventIntercepter {
    func requestData()
}

/// Логика подготовки данных для презентации
protocol PresentationLogik: AnyObject {
    func presentData(_ data: [FirstAidKit])
}

final class MedicinesPresenter {
    
    weak var view: DisplayLogic?
    var interactor: BusinessLogic?
    var router: MedicinesRouter?
}

extension MedicinesPresenter: EventIntercepter {
    func requestData() {
        interactor?.requestData()
    }
}

extension MedicinesPresenter: PresentationLogik {
    func presentData(_ data: [FirstAidKit]) {
        // Заглушка. Эмитация получения DTO и сбор модели данных из них
        let viewModels = data.map({ $0 })
        view?.display(viewModels)
    }
}
