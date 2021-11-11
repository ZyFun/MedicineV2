//
//  MedicinesPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

final class MedicinesPresenter {
    
    var view: MedicinesViewController?
    var interactor: MedicinesInteractor?
    var router: MedicinesRouter?
    
    func requestData() {
        interactor?.requestData()
    }
    
    func presentData(_ data: [String]) {
        // Заглушка. Эмитация получения DTO и сбор модели данных из них
        let viewModels = data.map({ $0 })
        view?.display(viewModels)
    }
}
