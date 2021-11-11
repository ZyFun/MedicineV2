//
//  MedicinesInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

protocol BusinessLogic {
    func requestData()
}

final class MedicinesInteractor {
    
    weak var presenter: PresentationLogik?
    
    let data = ["Анальгин", "Аспирин", "Маалокс", "Карбамазепин", "Парацетамол"]
}

// MARK: - BusinessLogic
extension MedicinesInteractor: BusinessLogic {
    func requestData() {
        // TODO: тут прописать обращение к базе данных
        // Заглушка
        presenter?.presentData(data)
    }
}
