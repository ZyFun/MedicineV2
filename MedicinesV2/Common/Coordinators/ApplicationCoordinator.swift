//
//  ApplicationCoordinator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 25.01.2023.
//

import Foundation

#warning("продолжить отюда")
// https://youtu.be/sM-AaI32hTc?t=1223

final class ApplicationCoordinator: BaseCoordinator {
    private let router: IRouter
    private let coordinatorFactory: ICoordinatorFactory
    private var isAuthorized = true
    
    init(router: IRouter, coordinatorFactory: ICoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        if isAuthorized {
            runMoveFlow()
        } else {
            runLoginFlow()
        }
    }
    
    private func runMoveFlow() {
        
    }
    
    private func runLoginFlow() {
        
    }
}
