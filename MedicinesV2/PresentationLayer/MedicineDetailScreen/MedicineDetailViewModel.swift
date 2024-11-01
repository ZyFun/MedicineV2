//
//  TestModel.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 06.10.2024.
//

import SwiftUI
import DTLogger

final class MedicineDetailViewModel: ObservableObject {
	enum ScreenState {
		case saveMedicine
		case saveError
		case deleteMedicine
		case medicineTake
		case takeError
		case dosageZero
	}

	// MARK: - Dependencies

	private let router: MedicineDetailRoutingLogic
	private let coreDataService: ICoreDataService?
	private let notificationManager: INotificationMedicineManager?
	private let logger: DTLogger?

	// MARK: - Property wrappers

	@Published var name: String
	@Published var type: String
	@Published var purpose: String
	@Published var activeIngredient: String // TODO: (79) Добавить возможность скрыть если не нужно
	@Published var manufacturer: String // TODO: (79) Добавить возможность скрыть если не нужно
	@Published var expiryDate: Date

	@Published var amount: String
	@Published var unitType: MEDUnitMenu.UnitType
	@Published var dosage: String

	@Published var userDescription: String // TODO: (79) Добавить возможность скрыть если

	@Published var isShowAlert: Bool = false
	/// Используется только для 17 iOS
	@Published var isShowCalendar: Bool = false

	// MARK: - Properties

	let currentFirstAidKit: DBFirstAidKit?
	let dbMedicine: DBMedicine?

	var configAlert: STAlertConfig = .init(
		text: "",
		style: .success,
		dismissAfter: 0.2
	)
	private(set) var screenAction: ScreenState = .medicineTake

	// MARK: - Initializer

	init(
		router: MedicineDetailRoutingLogic,
		coreDataService: ICoreDataService?,
		notificationManager: INotificationMedicineManager?,
		logger: DTLogger?,
		firstAidKit: DBFirstAidKit?,
		medicine: DBMedicine?
	) {
		self.coreDataService = coreDataService
		self.notificationManager = notificationManager
		self.logger = logger
		self.router = router
		self.currentFirstAidKit = firstAidKit
		self.dbMedicine = medicine

		self.name = medicine?.title ?? ""
		self.type = medicine?.type ?? ""
		self.purpose = medicine?.purpose ?? ""
		self.activeIngredient = medicine?.activeIngredient ?? ""
		self.manufacturer = medicine?.manufacturer ?? ""
		self.expiryDate = medicine?.expiryDate ?? .now
		self.amount = "\(medicine?.amount?.stringValue ?? "")"
		self.dosage = medicine?.stepCountForStepper?.stringValue ?? ""
		self.userDescription = medicine?.userDescription ?? ""
		self.unitType = MEDUnitMenu.UnitType(rawValue: medicine?.unitType ?? "шт") ?? .pcs
	}

	// MARK: - Navigation

	func routeTo(_ screen: MedicineDetailRouter.Targets) {
		router.routeTo(target: screen)
	}

	private func showAlert(
		message: LocalizedStringKey,
		type: STAlertStyle,
		duration: Double = 3
	) {
		configAlert = .init(text: message, style: type, dismissAfter: duration)

		DispatchQueue.main.async {
			self.isShowAlert = true
		}
	}

	/// Метод для запуска действия по окончанию отображения алерта
	/// - так же этот метод показывает нужный алерт
	func runAfterUser(action: ScreenState) {
		screenAction = action

		switch action {
		case .saveMedicine:
			showAlert(
				message: "Данные сохранены",
				type: .success,
				duration: 1.5
			)
		case .deleteMedicine:
			showAlert(
				message: "Лекарство удалено",
				type: .success,
				duration: 1.5
			)
		case .medicineTake:
			showAlert(
				message: "Лекарство было принято",
				type: .info
			)
		case .saveError:
			showAlert(
				message: "Поле с названием не должно быть пустым",
				type: .error
			)
		case .takeError:
			showAlert(
				message: "Недостаточно лекарства в наличии",
				type: .error
			)
		case .dosageZero:
			showAlert(
				message: "Доза приёма не должна быть 0",
				type: .error
			)
		}
	}

	// MARK: - Internal methods

	func takeMedicine() {
		var amount = amount.doubleValue

		if dosage.doubleValue == 0 {
			runAfterUser(action: .dosageZero)
		} else if amount >= dosage.doubleValue && amount != .zero {
			amount -= dosage.doubleValue
			self.amount = String(format: "%.2f", amount)
			runAfterUser(action: .medicineTake)
		} else {
			runAfterUser(action: .takeError)
		}
	}

	// MARK: - CRUD

	/// Сохранение или создание нового лекарства
	/// - Если лекарство nil, создаётся новое лекарство. Если нет, идет редактирование текущего
	/// лекарства.
	/// - После сохранения лекарства, идет возврат на предыдущий экран.
	func createMedicine() {
		// Защита на отсутствие значения
		if name == "" {
			runAfterUser(action: .saveError)
			return
		}

		let dateCreated = self.constructDateCreation(dbMedicine)

		let medicine = MedicineModel(
			dateCreated: dateCreated,
			title: name,
			type: type,
			purpose: purpose,
			amount: amount.doubleValue,
			unitType: unitType.rawValue,
			stepCountForStepper: dosage.doubleValue,
			activeIngredient: activeIngredient,
			manufacturer: manufacturer,
			expiryDate: expiryDate,
			userDescription: userDescription
		)

		coreDataService?.performSave { [weak self] context in
			guard let self else { return }

			var firstAidKit: DBFirstAidKit?

			self.coreDataService?.fetch(DBFirstAidKit.self, from: context) { result in
				switch result {
				case .success(let dbFirstAidKits):
					firstAidKit = self.fetchFirstAidKit(
						from: dbFirstAidKits,
						for: self.currentFirstAidKit
					)
				case .failure(let error):
					self.logger?.log(.error, error.localizedDescription)
				}
			}

			// Если лекарство не выбрано, создаём новое
			if let dbMedicine {
				self.coreDataService?.update(dbMedicine, newData: medicine, context: context)
				self.notificationManager?.deleteNotification(for: dbMedicine)
			} else {
				self.coreDataService?.create(medicine, in: firstAidKit, context: context)
			}

			self.notificationManager?.addToQueueNotificationExpiredMedicine(data: medicine)
			self.runAfterUser(action: .saveMedicine)
		}
	}

	/// Метод для получения текущей аптечки из другого контекста
	/// - Parameters:
	///   - firstAidKits: Принимает аптечки в текущий контекст для фильтрации
	///   - currentFirstAidKit: Принимает текущую аптечку из другого контекста  для поиска
	///     нужной в текущем контексте по ID
	/// - Returns: Возвращает найденную аптечку
	/// - Метод необходим для правильной работы с данными в разных контекстах
	private func fetchFirstAidKit(
		from firstAidKits: [DBFirstAidKit],
		for currentFirstAidKit: DBFirstAidKit?
	) -> DBFirstAidKit? {

		guard let currentFirstAidKitID = currentFirstAidKit?.objectID else {
			logger?.log(.error, "Не удалось найти ID объекта")
			return nil
		}

		if let firstAidKit = firstAidKits.filter({ $0.objectID == currentFirstAidKitID }).first {
			return firstAidKit
		} else {
			logger?.log(.warning, "Объект не найден")
			return nil
		}
	}

	/// Метод для построения даты создания
	/// - Parameter dbMedicine: принимает текущую аптечку
	/// - Returns: возвращает дату из базы или новую текущую
	private func constructDateCreation(_ dbMedicine: DBMedicine?) -> Date {
		if let dateCreated = dbMedicine?.dateCreated {
			return dateCreated
		} else {
			return Date()
		}
	}

	func deleteMedicine() {
		coreDataService?.performSave { [weak self] context in
			guard let self else { return }
			guard let dbMedicine else { return }
			self.notificationManager?.deleteNotification(for: dbMedicine)
			self.coreDataService?.delete(dbMedicine, context: context)
			self.updateNotificationBadge()
			self.runAfterUser(action: .deleteMedicine)
		}
	}

	// MARK: - Notification

	func updateNotificationBadge() {
		DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
			let data = self.coreDataService?.fetchRequest(
				String(describing: DBMedicine.self)
			) as? [DBMedicine]
			self.notificationManager?.setupBadgeForAppIcon(data: data)
		}
	}

	// MARK: - Validate methods

	/// Метод для ограничения ввода символов и точек с запятыми
	func validateInput(_ text: String) -> String {
		let regex = "^[0-9]{1,6}([.,][0-9]{0,2})?$" // TODO: (MEDIC-86) Вместо строки обернуть в //
		if text.range(of: regex, options: .regularExpression) != nil {
			return text
		} else {
			return String(text.dropLast())
		}
	}
}
