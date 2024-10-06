//
//  MedicinesRouter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import SwiftUI

/// Протокол логики роутера
protocol MedicinesRoutingLogiс {
    /// Переход к определенному экрану по таргету
    /// - Parameter target: таргет экрана, на который будет осуществлен переход
    func routeTo(target: MedicinesRouter.Target)
}

final class MedicinesRouter {
    
    private var navigationController: UINavigationController?
    
    init(withNavigationController: UINavigationController?) {
        navigationController = withNavigationController
    }
    
    /// Таргет для перехода на другой экран
    enum Target {
        /// Экран с подробной информацией о лекарстве, с передачей текущих (выбранных)
        /// аптечкой и лекарством
        /// - передача свойств нужна, для определения связи лекарства с аптечкой.
        case medicine(DBFirstAidKit?, DBMedicine?)
    }
    
}

extension MedicinesRouter: MedicinesRoutingLogiс {
    func routeTo(target: MedicinesRouter.Target) {
        switch target {
        case .medicine(let currentFirstAidKit, let currentMedicine):
			let viewController = PresentationAssembly().medicineSUI.config(
				navigationController: navigationController,
				firstAidKit: currentFirstAidKit,
				medicine: currentMedicine
			)

            // Навигация
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
