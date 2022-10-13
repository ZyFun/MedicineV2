//
//  AppDelegate.swift
//  MedicineV2
//
//  Created by Дмитрий Данилин on 05.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let notificationService = NotificationService.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        createAndShowStartVC()
        notificationService.requestAuthorization()
        
        return true
    }

}

// MARK: - Initial application settings

private extension AppDelegate {
    /// Создание и отображение стартового ViewController
    func createAndShowStartVC() {
        let mainVC = FirstAidKitsViewController(
            nibName: String(describing: FirstAidKitsViewController.self),
            bundle: nil
        )
        
        let navigationController = UINavigationController(
            rootViewController: mainVC
        )
        
        // Конфигурирование VIPER модуля для инжектирования зависимостей
        PresentationAssembly().firstAidKits.config(
            view: mainVC,
            navigationController: navigationController
        )
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
