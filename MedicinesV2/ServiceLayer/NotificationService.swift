//
//  NotificationService.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 07.09.2022.
//

import UIKit
import UserNotifications
import DTLogger

protocol INotificationService {
    var notificationCenter: UNUserNotificationCenter { get }
    
    /// Метод получения запроса у пользователя для разрешения на отправку уведомлений
    func requestAuthorization()
    
    /// Метод для установки получения уведомления
    /// - Parameters:
    ///   - reminder: принимает дату, на которую будет установлено уведомление
    ///   - nameMedicine: принимает название лекарства
    ///   - dateCreated: дата создания лекарства, для дополнения ключа идентификации
    ///   уведомления.
    ///   - isRepeat: принимает настройку, повторять уведомления или нет
    ///   - hourNotifiable: принимает час, в который будет приходить уведомление
    func sendNotificationExpiredMedicine(
        reminder: Date?,
        nameMedicine: String,
        dateCreated: Date,
        isRepeat: Bool,
        hourNotifiable: Int
    )
    
    /// Метод для отображения бейджев на иконке приложения с количеством просроченных лекарств
    /// - Parameter count: принимает количество просроченных лекарств для установки бейджа
    ///   на иконку приложения с правильным номером
    func setupBadge(count: Int)
}

final class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    
    // Создаём экземпляр класса, для управлением уведомлениями. current возвращет обект для центра уведомлений
    var notificationCenter = UNUserNotificationCenter.current()
    let logger = DTLogger.shared
    
    private override init() {
        super.init()
        
        notificationCenter.delegate = self
    }
    
    // Метод для показа уведомлений во время активного приложения
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        
        // Отображаем уведомление со звуком
        completionHandler([.list, .sound])
    }
}

extension NotificationService: INotificationService {
    
    func requestAuthorization() {
        // Метод запроса авторизации. options это те уведомления которые мы
        // хотим отправлять. granted обозначает, прошла авторизация или нет
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (granted, _) in
            self?.logger.log(.info, "Разрешение получено: \(granted)")
            
            guard granted else { return }
            // Запрашиваем состояние разрешений
            self?.getNotificationsSettings()
        }
    }
    
    /// Метод для отслеживания настроек (включены или отключены уведомления)
    private func getNotificationsSettings() {
        // Проверяем состояние авторизаций или параметров уведомлений
        // TODO: (#Update) Посмотреть как можно запросить к примеру включить уведомления обратно, если пользователь их отключил
        notificationCenter.getNotificationSettings { [weak self] settings in
            self?.logger.log(.info, "Настройки получены: \(settings)")
        }
    }
    
    func sendNotificationExpiredMedicine(
        reminder: Date?,
        nameMedicine: String,
        dateCreated: Date,
        isRepeat: Bool,
        hourNotifiable: Int
    ) {
        guard let date = reminder else { return }
        
        // Создаём экземпляр класса календаря, для разбивки на компоненты полученной даты
        let calendar = Calendar.current
        var component: DateComponents
        if date <= Date() {
            component = calendar.dateComponents([.hour, .minute, .second], from: date)
        } else {
            component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        }
        
        let hour = hourNotifiable > 23 && hourNotifiable < 0 ? 23 : hourNotifiable
        component.hour = hour
        component.minute = 0
        component.second = 0
        
        // Создаём триггер срабатывания уведомления по календарю
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: isRepeat)
        
        // Создаём экземпляр класса. Для настройки контента уведомлений
        let content = UNMutableNotificationContent()
        content.title = "Лекарство просрочено"
        content.body = "Пора выбросить лекарство: \(nameMedicine)"
        content.sound = UNNotificationSound.default
        
        let dateCreated = dateCreated.toString(format: "_MM-dd-yyyy_HH:mm:ss")
        // Имя+дата создания нужны для уникальной идентификации лекарства,
        // если имя будет одинаковое.
        let identifier = nameMedicine + dateCreated
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { [weak self] error in
            if let error = error {
                self?.logger.log(.error, "Error: \(error.localizedDescription)")
                // TODO: (#Explore) Принт из примера обработки ошибок, хочу посмотреть что он покажет если что то пойдет не так
                self?.logger.log(.error, "\(error as Any)")
            }
            
            self?.logger.log(.info, "Добавлено уведомление для лекарства: \(identifier)")
        }
    }
    
    func setupBadge(count: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
    
    //    // TODO: (#Update) Добавить метод, чтобы при нажатии на уведомление происходил вход в аптечку с лекарством
    //    // Метод для того, чтобы по нажатию на уведомление, что то происходило (пример с одного из уроков)
    //    func userNotificationCenter(
    //        _ center: UNUserNotificationCenter,
    //        didReceive response: UNNotificationResponse,
    //        withCompletionHandler completionHandler: @escaping () -> Void
    //    ) {
    //
    //        // Создаём действие которое происходит по нажатию на уведомление
    //        if response.notification.request.identifier == "Local Notification" {
    //            print("На уведомление нажали")
    //        }
    //
    //        completionHandler()
    //    }
}
