//
//  MedicinesConfigurator.swift.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

/// Конфигурация VIPER модуля
final class MedicinesConfigurator {
    /// Свойство для передачи аптечки на экран лекарств
    private let firstAidKit: FirstAidKit?
    
    /// Передача текущей аптечки на экран с лекарствами
    /// - Используется для привязки лекарства к аптечке и фильтрации лекарств привязанных к
    /// аптечке
    /// - Parameter firstAidKit: принимает текущую аптечку
    init(firstAidKit: FirstAidKit) {
        self.firstAidKit = firstAidKit
    }
    
    func config(view: UIViewController, navigationController: UINavigationController?) {
        guard let view = view as? MedicinesViewController else { return }
        
        // Передача выбранной аптечки на новый экран
        view.currentFirstAidKit = firstAidKit
        
        let presenter = MedicinesPresenter()
        let interactor = MedicinesInteractor()
        let router = MedicinesRouter(withNavigationController: navigationController)
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
    }
}
