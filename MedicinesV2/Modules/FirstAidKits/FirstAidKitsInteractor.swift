//
//  FirstAidKitsInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import Foundation

protocol FirstAidKitsBusinessLogic {
    func requestData()
}

final class FirstAidKitInteractor {
    weak var presenter: FirstAidKitsPresentationLogic?
    
    var data: FirstAidKit?
}

extension FirstAidKitInteractor: FirstAidKitsBusinessLogic {
    func requestData() {
        presenter?.presentData(data)
    }
}
