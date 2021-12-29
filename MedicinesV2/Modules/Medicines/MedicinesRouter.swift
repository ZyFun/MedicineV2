//
//  MedicinesRouter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

protocol MedicinesRoutingLogik {
    func routeTo(target: MedicinesRouter.Target)
}

final class MedicinesRouter {
    
    weak var navigationController: UINavigationController?
    
    init(withNavigationController: UINavigationController?) {
        navigationController = withNavigationController
    }
    
    enum Target {
        case medicine(FirstAidKit?, Medicine?)
    }
    
}

extension MedicinesRouter: MedicinesRoutingLogik {
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
