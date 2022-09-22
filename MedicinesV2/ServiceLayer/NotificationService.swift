//
//  NotificationService.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 07.09.2022.
//
// TODO: ([07.09.2022]) Это старый код из прошлой версии, нужно разобраться и доработать.

import UIKit
import UserNotifications

protocol INotificationService {
    var notificationCenter: UNUserNotificationCenter { get }
    func requestAuthorisation()
    func sendNotificationExpiredMedicine(reminder: Date?, nameMedicine: String)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    func setupBadge(count: Int)
}

final class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    
    // Создаём экземпляр класса, для управлением уведомлениями. current возвращет обект для центра уведомлений
    var notificationCenter = UNUserNotificationCenter.current()
    
    // Метод получения запроса у пользователя для разрешения на отправку уведомлений
    func requestAuthorisation() {
        
        // Метод запроса авторизации. options это те уведомления которые мы хотим отправлять. Булево значение обозночает, прошла авторизация или нет
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            Logger.info("Разрешение получено: \(granted)")
            
            guard granted else { return }
            // Запрашиваем состояние разрешений
            self.getNotificationsSettings()
        }
        
    }
    
    // Метод для отслеживания настроек (включены или отключены уведомления)
    private func getNotificationsSettings() {
        
        // Проверяем состояние авторизаций или параметров уведомлений
        // TODO: Посмотреть как можно запросить к примеру включить уведомления обратно, если пользователь их отключил
        notificationCenter.getNotificationSettings { (settings) in
            Logger.info("Настройки получены: \(settings)")
        }
        
    }
    
    // Создаём метод для получения даты из базы данных и получения уведомления
    func sendNotificationExpiredMedicine(reminder: Date?, nameMedicine: String) {
        
        // Безопасно извлекаем дату, и если не получилосб, выходим из функйии
        guard var date = reminder else { return }
        // Необходимо для того, чтобы получать уведомление о просроченном лекарстве каждый день, раздражая пользователя, и заставляя выбросить лекарство из аптечки.
        // TODO: Стоит реализовать настройку, чтобы пользователь выбирал, напоминать 1 раз или каждый день, пока лекарство не выброшено из аптечки
        if date <= Date() {
            date = Date()
        }
        
        // Создаём экземпляр класса календаря, для разбивки на компоненты полученной даты
        let calendar = Calendar.current // TODO: Что делает current?
        // Выбираем компоненты, по которым будет срабатывать триггер из полученной даты
        var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        // Указываем точное время срабатывания уведомлений
        // TODO: Стоит реализовать настройку для пользователей, чтобы они сами выбирали удобное время уведомлений
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
            content.badge = 1 // TODO: Сделать в будущем так, чтобы +1 было уже к имеющимся бейджам. Уточнить, возможно ли это сделать
        }
        
        content.sound = UNNotificationSound.default
        
        // Создаём идентификатор для запроса уведомления
        let identifier = "\(nameMedicine)" // Таким образом для каждого уведомления будет свой идентификатор, и для каждого лекарства будет своё уведомление о просрочке.
        // Создаём запроса уведомления
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        // Вызываем запрос уведомления через центр уведомлений и обрабатываем ошибку, если что то пойдет не так
        notificationCenter.add(request) { (error) in
            if let error = error {
                Logger.error("Error: \(error.localizedDescription)")
                //TODO: Принт из примера обработки ошибок, хочу посмотреть что он покажет если что то пойдет не так
                Logger.error("\(error as Any)")
            }
        }
        
    }
    
    // Метод для показа уведомлений во время активного приложения
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Отображаем уведомление со звуком
        completionHandler([.alert, .sound])
        
    }
    
//    // TODO: Добавить метод, чтобы при нажатии на уведомление что то происзодило.
//    // Метод для того, чтобы по нажатию на уведомление, что то происходило (пример с одного из уроков)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        // Создаём действие которое происходит по нажатию на уведомление
//        if response.notification.request.identifier == "Local Notification" {
//            print("На уведомление нажали")
//        }
//        // Зачем то что то вызываем, он не объяснил зачем. Надо разобраться
//        completionHandler()
//    }
    
    // Метод для отображения бейджев на иконке приложения с количеством просроченных лекарств
    func setupBadge(count: Int) {
        UIApplication.shared.applicationIconBadgeNumber = count
    }
}

extension NotificationService: INotificationService {
    
}
