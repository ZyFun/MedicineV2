//
//  MedicineDetailRouter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 06.10.2024.
//

import UIKit

protocol MedicineDetailRoutingLogic {
	func routeTo(target: MedicineDetailRouter.Targets)
}

final class MedicineDetailRouter: MedicineDetailRoutingLogic {

	private var navigationController: UINavigationController?

	init(withNavigationController: UINavigationController?) {
		navigationController = withNavigationController
	}

	enum Targets {
		case back
	}

	func routeTo(target: MedicineDetailRouter.Targets) {
		switch target {
		case .back:
			DispatchQueue.main.async {
				self.navigationController?.popViewController(animated: true)
			}
		}
	}
}
