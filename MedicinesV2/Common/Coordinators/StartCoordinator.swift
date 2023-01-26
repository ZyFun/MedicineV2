//
//  StartCoordinator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 26.01.2023.
//

import Foundation

final class StartCoordinator: BaseCoordinator {
    
    var finishFlow: VoidClosure?
    
    private let screenFactory: IScreenFactory
    private let router: Router
    
    init(router: Router, screenFactory: IScreenFactory) {
        self.screenFactory = screenFactory
        self.router = router
    }
    
    override func start() {
        showMainScreen()
    }
    
    private func showMainScreen() {
        let mainScreen = screenFactory.makeMainScreen()
        mainScreen = { [weak self] in
            self?.finishFlow?()
        }
        router.setRootModule(mainScreen)
    }
}
