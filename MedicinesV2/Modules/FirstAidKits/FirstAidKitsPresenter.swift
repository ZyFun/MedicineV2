//
//  FirstAidKitsPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import Foundation

/// Логика подготовки данных для презентации
protocol FirstAidKitsPresentationLogic: AnyObject {
    func presentData(_ data: FirstAidKit?)
}

/// Логика получения данных
protocol FirstAidKitsViewControllerOutput {
    func requestData()
}

final class FirstAidKitsPresenter {
    weak var view: FirstAidKitsDisplayLogic?
    var interactor: FirstAidKitsBusinessLogic?
    var router: FirstAidKitRoutingLogic?
}

extension FirstAidKitsPresenter: FirstAidKitsViewControllerOutput {
    func requestData() {
        interactor?.requestData()
    }
}

extension FirstAidKitsPresenter: FirstAidKitsPresentationLogic {
    func presentData(_ data: FirstAidKit?) {
        view?.display(data)
    }
}
