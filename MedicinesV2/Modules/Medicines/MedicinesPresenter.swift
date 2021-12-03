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
    func presentData(_ data: [Medicine]?)
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
    func presentData(_ data: [Medicine]?) {
        guard let viewModels = data.map({ $0 }) else { return }
        view?.display(viewModels)
    }
}
