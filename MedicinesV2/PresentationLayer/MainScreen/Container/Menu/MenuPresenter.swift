//
//  MenuPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.03.2023.
//

import Foundation

/// Протокол взаимодействия ViewController-a с презенетром
protocol MenuPresentationLogic: AnyObject {
    init(view: MenuView)
    
    func presentAboutAppScreen()
}

final class MenuPresenter {
    // MARK: - Public Properties
    
    weak var view: MenuView?
    var router: MenuRoutingLogic?
    
    // MARK: - Initializer
    
    required init(view: MenuView) {
        self.view = view
    }
}

// MARK: - Presentation Logic

extension MenuPresenter: MenuPresentationLogic {
    func presentAboutAppScreen() {
        router?.routeTo(target: .aboutApp)
    }
}
