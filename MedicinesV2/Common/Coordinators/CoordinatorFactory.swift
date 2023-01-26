//
//  CoordinatorFactory.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 25.01.2023.
//

import Foundation

protocol ICoordinatorFactory {
    func makeApplicationCoordinator(router: Router) -> ApplicationCoordinator
//    func makeLoginCoordinator(router: Router) -> LoginCoordinator
//    func makeMovieCoordinator(router: Router) -> MoviesCoordinator
    func makeStartCoordinator(router: Router) -> StartCoordinator
}

final class CoordinatorFactory: ICoordinatorFactory {
    private let screenFactory: IScreenFactory
    
    fileprivate init(screenFactory: IScreenFactory) {
        self.screenFactory = screenFactory
    }
    
    func makeApplicationCoordinator(router: Router) -> ApplicationCoordinator {
        return ApplicationCoordinator(router: router, coordinatorFactory: self)
    }
    
//    func makeLoginCoordinator(router: Router) -> LoginCoordinator {
//        return LoginCoordinator(router: router, screenFactory: screenFactory)
//    }
//
//    func makeMovieCoordinator(router: Router) -> MoviesCoordinator {
//        return MoviesCoordinator(router: router, screenFactory: screenFactory)
//    }
//
    func makeStartCoordinator(router: Router) -> StartCoordinator {
        return StartCoordinator(router: router, screenFactory: screenFactory)
    }
}
