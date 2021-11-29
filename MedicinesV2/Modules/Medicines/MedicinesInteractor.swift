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
    
    var data: [FirstAidKit] = []
}

// MARK: - BusinessLogic
extension MedicinesInteractor: BusinessLogic {
    func requestData() {
        // TODO: тут прописать обращение к базе данных
        // Заглушка
//        StorageManager.shared.fetchData { result in
//            switch result {
//            case .success(let firstAidKits):
//                data = firstAidKits
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        presenter?.presentData(data)
    }
}
