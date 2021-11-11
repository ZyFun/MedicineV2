//
//  MedicinesInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

final class MedicinesInteractor {
    
    var presenter: MedicinesPresenter?
    
    let data = ["Анальгин", "Аспирин", "Маалокс", "Карбамазепин", "Парацетамол"]
    
    func requestData() {
        // TODO: тут прописать обращение к базе данных
        // Заглушка
        presenter?.presentData(data)
    }
}
