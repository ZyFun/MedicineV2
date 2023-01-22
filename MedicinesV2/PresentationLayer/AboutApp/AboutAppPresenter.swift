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
    /// Метод для открытия ссылки на группу в Telegram
    func openTGUrl()
    /// Метод для открытия ссылки на группу в ВКонтакте
    func openVKUrl()
    /// Метод выхода с экрана
    func dismiss()
}

final class AboutAppPresenter {
    // MARK: - Public Properties
    
    weak var view: AboutAppView?
    
    // MARK: - Private properties
    
    private let infoModel: AboutAppInfoModel
    
    // MARK: - Initializer
    
    required init(view: AboutAppView, infoModel: AboutAppInfoModel) {
        self.view = view
        self.infoModel = infoModel
    }
}

// MARK: - Presentation Logic

extension AboutAppPresenter: AboutAppPresentationLogic {
    // MARK: - Presentation
    
    func presentAppInfo() {
        view?.setAppInfo(from: infoModel)
    }
    
    // MARK: - URL links
    
    func openTGUrl() {
        guard let urlString = infoModel.tgUrl else {
            CustomLogger.error("URL в модели отсутствует")
            return
        }
        
        if let url = URL(string: urlString) {
            view?.open(url: url)
        }
    }
    
    func openVKUrl() {
        guard let urlString = infoModel.vkUrl else {
            CustomLogger.error("URL в модели отсутствует")
            return
        }
        
        if let url = URL(string: urlString) {
            view?.open(url: url)
        }
    }
    
    // MARK: - Navigation
    
    func dismiss() {
        view?.dismiss()
    }
}
