//
//  MedicinesConfigurator.swift.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

/// Конфигурация VIPER модуля
final class MedicinesConfigurator {
    func config(view: UIViewController, navigationController: UINavigationController?) {
        guard let view = view as? MedicinesViewController else { return }
        
        let presenter = MedicinesPresenter()
        let interactor = MedicinesInteractor()
        
        // TODO: На данном этапе проекта, этот модуль не нужен, но сделан для того, чтобы понимать как работает вся архитектура, реализовать подобное при инициализации модуля с аптечками
        let router = MedicinesRouter()
        router.navigationController = navigationController
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
    }
}
