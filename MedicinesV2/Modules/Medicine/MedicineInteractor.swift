//
//  MedicineInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.12.2021.
//

import Foundation

protocol MedicineBusinessLogic {
    func requestData(at indexPath: IndexPath)
}

final class MedicineInteractor {
    weak var presenter: MedicinePresentationLogic?
}

extension MedicineInteractor: MedicineBusinessLogic {
    func requestData(at indexPath: IndexPath) {
        // TODO: Доделать
    }
}
