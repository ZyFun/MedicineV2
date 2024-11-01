//
//  SettingsPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 16.05.2023.
//

import Foundation
import DTLogger

/// Протокол взаимодействия ViewController-a с презенетром
protocol SettingsPresentationLogic: AnyObject {
    init(view: SettingsView)
    
    func getSettingsSections()
    func saveSettings()
}

final class SettingsPresenter {
    // MARK: - Public Properties
    
    weak var view: SettingsView?
    
    // MARK: - Dependencies
    
    var notificationSettingService: NotificationSettings?
    var sortingSettingService: SortableSettings?
	var coreDataService: ICoreDataService?
	var notificationManager: INotificationMedicineManager?
    var logger: DTLogger?
    
    // MARK: - Private properties
    
    private var sections: [SettingSections] = []
    
    // Заданы настройки по умолчанию, если пользователь еще не выбирал их
    private var timeName: TimeNotification = .evening
    private var isRepeatNotification: Bool = true
    
    private var ascendingName: SortAscending = .down
    private var fieldName: SortField = .dateCreated
    
    // MARK: - Initializer
    
    required init(view: SettingsView) {
        self.view = view
    }
}

// MARK: - Presentation Logic

extension SettingsPresenter: SettingsPresentationLogic {
    func getSettingsSections() {
        createNotificationSection()
        createSortingSection()
        
        view?.show(sections: sections)
    }
    
    private func createNotificationSection() {
        var notificationSettingModel: NotificationSettingModel?
        
        // Получаем модель данных из UserDefaults
        do {
            notificationSettingModel = try notificationSettingService?.getNotificationSettings()
        } catch {
            logger?.log(.error, error.localizedDescription)
        }
        
        // Задаём время уведомления из модели
        if let time = notificationSettingModel?.hourNotifiable {
            switch time {
            case 0...9: timeName = .morning
            case 10...14: timeName = .day
            case 15...23: timeName = .evening
            default: logger?.log(.warning, "Пользователь еще не сохранял настройки, значение задано по умолчанию")
            }
        }
        
        // Задаём условия повтора из модели
        if let isRepeat = notificationSettingModel?.isRepeat {
            isRepeatNotification = isRepeat
        }
        
        // Создаём и отображаем ячейки секции
        let notificationSettingModels = [
            NotificationSettingCellModel(
                settingName: String(localized: "Время"),
                buttonName: timeName
            ),
            NotificationSettingCellModel(
                settingName: "Повтор",
                isRepeat: isRepeatNotification
            )
        ]
        
        let settingSection = NotificationSectionViewModel(
            titleSection: "Уведомления",
            viewModels: notificationSettingModels
        )
        
        sections.append(SettingSections.notification(settingSection))
    }
    
    private func createSortingSection() {
        // Получаем данные из UserDefaults
        if let ascending = sortingSettingService?.getSortAscending() {
            ascendingName = ascending ? .up : .down
        }
        
        if let field = sortingSettingService?.getSortField() {
            fieldName = SortField(rawValue: field) ?? .dateCreated
        }
        
        // Создаём и отображаем ячейки секции
        let sortingSettingModels = [
            SortingSettingCellModel(
                settingName: "Направление",
                ascending: ascendingName
            ),
            SortingSettingCellModel(
                settingName: "Поле",
                field: fieldName
            )
        ]
        
        let sortingSection = SortingSectionViewModel(
            titleSection: "Сортировка",
            viewModels: sortingSettingModels
        )
        
        sections.append(SettingSections.sorting(sortingSection))
    }
    
    // FIXME: Необходимо переписать так, чтобы после срабатывания вызывалось обновление уведомлений.
    // Сейчас обновления происходят методом жизненного цикла ``FirstAidKitsViewController`` ,
    // после того как настройки были закрыты.
    /// Метод для сохранения настроек
    /// - warning: Очередь уведомлений обновляется после выхода с экрана настроек
    func saveSettings() {
        saveNotifications()
        saveSortSettings()
    }
    
    private func saveNotifications() {
        do {
            try notificationSettingService?.saveNotificationSettings(
                hourNotifiable: timeName.value,
                isRepeat: isRepeatNotification
            )
			updateAllNotifications()
        } catch {
            logger?.log(.error, error.localizedDescription)
        }
    }
    
    private func saveSortSettings() {
        switch fieldName {
        case .title:
            sortingSettingService?.saveSortSetting(field: .title)
        case .dateCreated:
            sortingSettingService?.saveSortSetting(field: .dateCreated)
        case .expiryDate:
            sortingSettingService?.saveSortSetting(field: .expiryDate)
        }
        
        switch ascendingName {
        case .up:
            sortingSettingService?.saveSortSetting(ascending: .up)
        case .down:
            sortingSettingService?.saveSortSetting(ascending: .down)
        }
    }

	private func updateAllNotifications() {
		let medicines = coreDataService?.fetchRequest(String(describing: DBMedicine.self)) as? [DBMedicine]
		
		medicines?.forEach { medicine in
			logger?.log(.info, "Начало обработки уведомления для лекарства: \(medicine.title ?? "NoName")")
			notificationManager?.addToQueueNotificationExpiredMedicine(data: medicine)
			logger?.log(.info, "Уведомление в очереди обновлено")
		}
	}
}

// MARK: - NotificationCellDelegate

extension SettingsPresenter: NotificationCellDelegate {
    func didSelectTimeNotification(time: TimeNotification) {
        logger?.log(.info, "Уведомления настроены на \(time.value) часов")
        timeName = time
    }
    
    func didToggleSwitched(isRepeat: Bool) {
        logger?.log(.info, "Повторять уведомления после отображения: \(isRepeat)")
        isRepeatNotification = isRepeat
    }
}

// MARK: - SortingCellDelegate

extension SettingsPresenter: SortingCellDelegate {
    func didSelectSort(ascending: SortAscending) {
        logger?.log(.info, "Направление сортировки: \(ascending.description)")
        ascendingName = ascending
    }
    
    func didSelectSort(field: SortField) {
        logger?.log(.info, "Поле сортировки: \(field.rawValue)")
        fieldName = field
    }
}
