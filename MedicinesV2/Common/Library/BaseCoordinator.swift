//
//  Coordinator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 25.01.2023.
//

import Foundation

protocol Coordinator: AnyObject {
    func start()
}

class BaseCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    
    func start() {}
    
    func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinator.contains(where: { $0 === coordinator }) else { return }
        childCoordinator.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
        guard
            childCoordinator.isEmpty == false,
            let coordinator = coordinator
        else { return }
        
        if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinator.isEmpty {
            coordinator.childCoordinator
                .filter({ $0 !== coordinator })
                .forEach({ coordinator.removeDependency($0) })
        }
        
        for (index, element) in childCoordinator.enumerated() where element === coordinator {
            childCoordinator.remove(at: index)
            break
        }
    }
}
