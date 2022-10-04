//
//  NotificationService.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 07.09.2022.
//

import UIKit
import UserNotifications

protocol INotificationService {
    var notificationCenter: UNUserNotificationCenter { get }
    /// Метод получения запроса у пользователя для разрешения на отправку уведомлений
    func requestAuthorization()
    /// Метод для получения даты из базы данных и получения уведомления
    /// - Parameters:
    ///   - reminder: принимает дату, на которую будет установлено уведомление
    ///   - nameMedicine: принимает название лекарства
    func sendNotificationExpiredMedicine(reminder: Date?, nameMedicine: String)
    /// Метод для отображения бейджев на иконке приложения с количеством просроченных лекарств
    /// - Parameter count: принимает количество просроченных лекарств для установки бейджа
    ///   на иконку приложения с правильным номером
    func setupBadge(count: Int)
}

final class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    
    // Создаём экземпляр класса, для управлением уведомлениями. current возвращет обект для центра уведомлений
    var notificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        
        // Нужен, чтобы уведомление отображалось при активном приложении
        // Инитим тут, так как класс синглтон и висит в памяти всегда.
        notificationCenter.delegate = self
    }
    
    // Метод для показа уведомлений во время активного приложения
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        
        // Отображаем уведомление со звуком
        completionHandler([.alert, .sound])
    }
}

extension NotificationService: INotificationService {
    
    func requestAuthorization() {
        // Метод запроса авторизации. options это те уведомления которые мы
        // хотим отправлять. granted обозначает, прошла авторизация или нет
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
            CustomLogger.info("Разрешение получено: \(granted)")
            
            guard granted else { return }
            // Запрашиваем состояние разрешений
            self.getNotificationsSettings()
        }
    }
    
    /// Метод для отслеживания настроек (включены или отключены уведомления)
    private func getNotificationsSettings() {
        // Проверяем состояние авторизаций или параметров уведомлений
        // TODO: (#Update) Посмотреть как можно запросить к примеру включить уведомления обратно, если пользователь их отключил
        notificationCenter.getNotificationSettings { (settings) in
            CustomLogger.info("Настройки получены: \(settings)")
        }
    }
    
    func sendNotificationExpiredMedicine(reminder: Date?, nameMedicine: String) {
        guard var date = reminder else { return }
        // Необходимо для того, чтобы получать уведомление о просроченном
        // лекарстве каждый день, раздражая пользователя, и заставляя выбросить
        // лекарство из аптечки.
        // TODO: (#Update) Стоит реализовать настройку, чтобы пользователь выбирал, напоминать 1 раз или каждый день, пока лекарство не выброшено из аптечки
        if date <= Date() {
            date = Date()
        }
        
        // Создаём экземпляр класса календаря, для разбивки на компоненты полученной даты
        let calendar = Calendar.current
        // Выбираем компоненты, по которым будет срабатывать триггер из полученной даты
        var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        // Указываем точное время срабатывания уведомлений
        // TODO: (#Update) Стоит реализовать настройку для пользователей, чтобы они сами выбирали удобное время уведомлений
        component.hour = 20
        component.minute = 0
        component.second = 0
        // Создаём триггер срабатывания уведомления по календарю
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
        
        // Создаём экземпляр класса. Для настройки контента уведомлений
        let content = UNMutableNotificationContent()
        // Настраиваем контент для показа
        content.title = "Лекарство просрочено"
        content.body = "Пора выбросить лекарство: \(nameMedicine)"
        
        if content.badge == 0 {
            // TODO: (#Update) Сделать в будущем так, чтобы +1 было уже к имеющимся бейджам.
            content.badge = 1
        }
        
        content.sound = UNNotificationSound.default
        
        let identifier = "\(nameMedicine)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                CustomLogger.error("Error: \(error.localizedDescription)")
                // TODO: (#Explore) Принт из примера обработки ошибок, хочу посмотреть что он покажет если что то пойдет не так
                CustomLogger.error("\(error as Any)")
            }
            
            CustomLogger.info("Добавлено уведомление для лекарства: \(identifier)")
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
