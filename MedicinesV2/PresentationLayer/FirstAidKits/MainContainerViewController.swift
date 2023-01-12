//
//  MainContainerViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.01.2023.
//

import UIKit

#warning("отрефакторить весь класс")
final class MainContainerViewController: UIViewController {
    
    // Пока не понятно зачем он нужен отдельно от функции и глобально для класса
    var mainVC: UIViewController!
    var menuVC: UIViewController!
    var isMove = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFirstAidKitController()
    }
    
    /// Конфигурирование VIPER модуля для инжектирования зависимостей
    func configureFirstAidKitController() {
        let firstAidKitsVC = FirstAidKitsViewController(
            nibName: String(describing: FirstAidKitsViewController.self),
            bundle: nil
        )
        firstAidKitsVC.delegate = self
        
        let navigationController = UINavigationController(
            rootViewController: firstAidKitsVC
        )
        
        mainVC = navigationController
        view.addSubview(mainVC.view)
        addChild(mainVC)
        
        PresentationAssembly().firstAidKits.config(
            view: firstAidKitsVC,
            navigationController: navigationController
        )
    }
    
    // TODO: (Fix) добавить weak self для замыкания
    func showMenuVC(shouldMove: Bool) {
        if shouldMove {
            // показываем меню
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut
            ) {
                // TODO: (#Fix) Сделать сдвиг не фиксированно 140, а на треть экрана рассчитав размер
                self.mainVC.view.frame.origin.x = self.mainVC.view.frame.width - 140
            }
        } else {
            // убираем меню
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut
            ) {
                self.mainVC.view.frame.origin.x = 0
            }
        }
    }
    
    /// Конфигурирование экрана меню
    func configureMenuController() {
        if menuVC == nil {
            menuVC = MenuViewController()
            view.insertSubview(menuVC.view, at: 0) // Контроллер с меню добавляется под контроллер с аптечкой
            addChild(menuVC)
            
            CustomLogger.warning("Экран с меню добавлен в стек")
        }
    }
    
}

// MARK: - FirstAidKitsControllerDelegate

extension MainContainerViewController: FirstAidKitsControllerDelegate {
    func toggleMenu() {
        configureMenuController()
        isMove.toggle()
        showMenuVC(shouldMove: isMove)
    }
}
