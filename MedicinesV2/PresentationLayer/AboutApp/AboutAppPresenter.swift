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
    func setDescription(_ description: String)
    /// Метод выхода с экрана
    func dismiss()
}

/// Протокол взаимодействия ViewController-a с презенетром
protocol AboutAppPresentationLogic: AnyObject {
    init(view: AboutAppOutput, info: AboutAppModel)
    func presentInfo()
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
    
    func presentInfo() {
        let version = self.info.version
        view.setDescription(version)
    }
    
    func dismiss() {
        view.dismiss()
    }
    
}
