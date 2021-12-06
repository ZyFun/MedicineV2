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
    
    var data: [Medicine]?
}

// MARK: - BusinessLogic
extension MedicinesInteractor: BusinessLogic {
        
    // TODO: Внедрить сюда функцию для работы с кордатой на прямую. Работа с таблицей и вся информация по изменениям будет передаваться сюда
    
    func requestData() {
        // TODO:  Не уверен что запись получения данных правильная
        data = StorageManager.shared.fetchRequest("Medicine") as? [Medicine]
        presenter?.presentData(data)
    }
}
