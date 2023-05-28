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
    var notificationSettingService: NotificationSettings?
    
    // MARK: - Private properties
    
    private var sections: [SettingSections] = []
    
    // Заданы настройки по умолчанию, если пользователь еще не выбирал их
    private var timeName: TimeNotification = .evening
    private var isRepeatNotification: Bool = true
    
    // MARK: - Initializer
    
    required init(view: SettingsView) {
        self.view = view
    }
}

// MARK: - Presentation Logic

extension SettingsPresenter: SettingsPresentationLogic {
    func getSettingsSections() {
        var notificationSettingModel: NotificationSettingModel?
        
        // Получаем модель данных из базы
        do {
            notificationSettingModel = try notificationSettingService?.getNotificationSettings()
        } catch {
            SystemLogger.error(error.localizedDescription)
        }
        
        // Задаём время уведомления из модели
        if let time = notificationSettingModel?.hourNotifiable {
            switch time {
            case 0...9: timeName = .morning
            case 10...14: timeName = .day
            case 15...23: timeName = .evening
            default:
                SystemLogger.warning("Пользователь еще не сохранял настройки, значение задано по умолчанию")
            }
        }
        
        // Задаём условия повтора из моделм
        if let isRepeat = notificationSettingModel?.isRepeat {
            isRepeatNotification = isRepeat
        }
        
        // Создаём и отображаем секции
        let notificationSettingModels = [
            NotificationSettingCellModel(
                settingName: "Время",
                buttonName: timeName
            ),
            NotificationSettingCellModel(
                settingName: "Повтор",
                isRepeat: isRepeatNotification
            )
        ]
        
        let settingSection = NotificationSectionViewModel(titleSection: "Уведомления", viewModels: notificationSettingModels)
        
        sections.append(SettingSections.notification(settingSection))
        
        view?.show(sections: sections)
    }
    
    /// Метод для сохранения настроек
    /// - warning: Очередь уведомлений обновляется после выхода с экрана настроек
    func saveSettings() {
        do {
            try notificationSettingService?.saveNotificationSettings(
                hourNotifiable: timeName.value,
                isRepeat: isRepeatNotification
            )
        } catch {
            SystemLogger.error(error.localizedDescription)
        }
        
        // FIXME: Необходимо переписать так, чтобы после срабатывания вызывалось обновление уведомлений.
        // Сейчас обновления происходят методом жизненного цикла ``FirstAidKitsViewController`` ,
        // после того как настройки были закрыты.
    }
}

extension SettingsPresenter: NotificationCellDelegate {
    func didSelectTimeNotification(time: TimeNotification) {
        SystemLogger.info("Уведомления настроены на \(time.value) часов")
        timeName = time
    }
    
    func didToggleSwitched(isRepeat: Bool) {
        SystemLogger.info("Повторять уведомления после отображения: \(isRepeat)")
        isRepeatNotification = isRepeat
    }
}
