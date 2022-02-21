//
//  MedicinesRouter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

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
    
    /// Кейсы с экранами, на которые возможно сделать переход по таргету
    enum Target {
        /// Таргет на экран с лекарством, с передачей текущих (выбранных) аптечкой и лекарством
        /// - передача свойств нужна, для определения связи лекарства с аптечкой.
        case medicine(FirstAidKit?, Medicine?)
    }
    
}

extension MedicinesRouter: MedicinesRoutingLogiс {
    func routeTo(target: MedicinesRouter.Target) {
        switch target {
        case .medicine(let currentFirstAidKit, let currentMedicine):
            // TODO: Переход так и будет идти к сториборду, потому что в xib нельзя сделать статические ячейки
            // Как вариант, в будущем использовать множество кастомных ячеек и каждую пихать по своему индексу.
            let storyboard = UIStoryboard(name: "MedicineViewController", bundle: nil)
            guard let medicineVC = storyboard
                    .instantiateViewController(
                        withIdentifier: "medicine"
                    ) as? MedicineViewController else { return }
            
            MedicineConfigurator(
                firstAidKit: currentFirstAidKit,
                medicine: currentMedicine
            )
                .config(
                    view: medicineVC,
                    navigationController: navigationController
                )
            
            navigationController?.pushViewController(medicineVC, animated: true)
        }
    }
}
