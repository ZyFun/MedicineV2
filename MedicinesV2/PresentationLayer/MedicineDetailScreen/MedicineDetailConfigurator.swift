//
//  MedicineDetailConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 06.10.2024.
//

import UIKit
import SwiftUI
import DTLogger

final class MedicineDetailConfigurator {
	private let coreDataService: ICoreDataService?
	private let notificationManager: INotificationMedicineManager?
	private let logger: DTLogger?

	init(
		coreDataService: ICoreDataService?,
		notificationManager: INotificationMedicineManager?,
		logger: DTLogger?
	) {
		self.coreDataService = coreDataService
		self.notificationManager = notificationManager
		self.logger = logger
	}

	func config(
		navigationController: UINavigationController?,
		firstAidKit: DBFirstAidKit?,
		medicine: DBMedicine?
	) -> UIViewController {

		let router = MedicineDetailRouter(withNavigationController: navigationController)
		let viewModel = MedicineDetailViewModel(
			router: router, coreDataService: coreDataService,
			notificationManager: notificationManager,
			logger: logger,
			firstAidKit: firstAidKit,
			medicine: medicine
		)
		let view = MedicineDetailView(viewModel: viewModel)
		let hostingController = UIHostingController(rootView: view)
		hostingController.title = medicine?.title ?? String(localized: "Новое лекарство")
		return hostingController
	}
}
