//
//  AboutAppPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 16.01.2023.
//

import Foundation

/// Протокол взаимодействия ViewController-a с презенетром
protocol AboutAppPresentationLogic: AnyObject {
    init(view: AboutAppView, infoModel: AboutAppInfoModel)
    func presentAppInfo()
    /// Метод выхода с экрана
    func dismiss()
}

final class AboutAppPresenter: AboutAppPresentationLogic {
    weak var view: AboutAppView?
    let infoModel: AboutAppInfoModel
    
    required init(view: AboutAppView, infoModel: AboutAppInfoModel) {
        self.view = view
        self.infoModel = infoModel
    }
    
    func presentAppInfo() {
        view?.setAppInfo(from: infoModel)
    }
    
    func dismiss() {
        view?.dismiss()
    }
    
}
