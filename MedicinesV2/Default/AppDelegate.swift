//
//  AppDelegate.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationService = NotificationService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Вызываем метод для запроса на отправку уведомлений
        notificationService.requestAuthorisation()
        
        // Назначаем делегата, чтобы уведомление отображалось при активном приложении
        notificationService.notificationCenter.delegate = notificationService
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // Вызывается при каждой выгрузке приложения из памяти. Срабатывает даже в момент падения приложения.
    func applicationWillTerminate(_ application: UIApplication) {
//        CoreDataService.shared.saveContext()
    }

}

