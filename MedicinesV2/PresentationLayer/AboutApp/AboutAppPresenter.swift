//
//  AboutAppPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 16.01.2023.
//

import Foundation

/// Протокол логики презентации данных
protocol AboutAppOutput: AnyObject {
    /// Метод установки описания информации о приложении
    func setVersion(_ version: String)
    /// Метод выхода с экрана
    func dismiss()
}

/// Протокол взаимодействия ViewController-a с презенетром
protocol AboutAppPresentationLogic: AnyObject {
    init(view: AboutAppOutput, info: AboutAppModel)
    func presentAppVersion()
    /// Метод выхода с экрана
    func dismiss()
}

class AboutAppPresenter: AboutAppPresentationLogic {
    let view: AboutAppOutput
    let info: AboutAppModel
    
    required init(view: AboutAppOutput, info: AboutAppModel) {
        self.view = view
        self.info = info
    }
    
    func presentAppVersion() {
        let version = self.info.version
        view.setVersion(version)
    }
    
    func dismiss() {
        view.dismiss()
    }
    
}
