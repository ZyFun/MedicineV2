//
//  MainContainerViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.01.2023.
//

import UIKit

// TODO: (#Refactor) Нужно отрефакторить модуль и привести к архитектуре MVP или VIPER
final class MainContainerViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var mainVC: UIViewController!
    private var menuVC: UIViewController!
    private var isDisplayed = false
    
    private var animator: IMainContainerAnimator?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
}

// MARK: - Конфигурирование ViewController

private extension MainContainerViewController {
    
    /// Метод инициализации VC
    func setup() {
        createFirstAidKitController()
        // TODO: (#Refactor) должно быть в презентере
        animator = MainContainerAnimator(mainVC: mainVC)
    }
    
    /// Конфигурирование VIPER модуля списка аптечек
    func createFirstAidKitController() {
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
    
    /// Конфигурирование экрана меню
    func createMenuController() {
        if menuVC == nil {
            menuVC = MenuViewController()
            view.insertSubview(menuVC.view, at: 0) // Контроллер с меню добавляется под контроллер с аптечкой
            addChild(menuVC)
        }
    }
    
    /// Метод для отображения или скрытия меню
    /// - Parameter isDisplayed:
    /// если значение true – отображает меню
    /// если значение false – скрывает меню
    func showMenuVC(_ isDisplayed: Bool) {
        if isDisplayed {
            animator?.animateAppearance()
        } else {
            animator?.animateDisappearance()
        }
    }
}

// MARK: - FirstAidKitsControllerDelegate

extension MainContainerViewController: FirstAidKitsControllerDelegate {
    func toggleDisplayMenu() {
        createMenuController()
        isDisplayed.toggle()
        showMenuVC(isDisplayed)
    }
}
