//
//  ApplicationCoordinator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 25.01.2023.
//

import Foundation

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
            runMainFlow()
        } else {
            
        }
    }
    
    private func runMainFlow() {
        
    }
}
