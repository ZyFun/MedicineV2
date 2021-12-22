//
//  FirstAidKitsRouter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import Foundation
import UIKit

protocol FirstAidKitRoutingLogic {
    func routeTo(target: FirstAidKitRouter.Targets)
}

final class FirstAidKitRouter: FirstAidKitRoutingLogic {
    
    private var navigationController: UINavigationController?
    
    init(withNavigationController: UINavigationController?) {
        navigationController = withNavigationController
    }
    
    enum Targets {
        case medicines
    }
    
    func routeTo(target: FirstAidKitRouter.Targets) {
        switch target {
        case .medicines:
            let medicinesVC = MedicinesViewController()
//            let medicinesConfigurator = TODO: Дописать
        }
    }
}
