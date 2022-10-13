//
//  SplashPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.10.2022.
//

import UIKit

protocol ISplashPresenter {
    func present()
    func dismiss(completion: (() -> Void)?)
}

final class SplashPresenter {
    
    // MARK: - Private properties
    
    private lazy var animator: ISplashAnimator = SplashAnimator(
        foregroundSplashWindow: foregroundSplashWindow,
        backgroundSplashWindow: backgroundSplashWindow
    )
    
    private lazy var foregroundSplashWindow: UIWindow = {
        var splashVC = createSplashVC(logoIsHidden: false)
        
        return splashWindow(
            level: .normal + 1,
            rootViewController: splashVC
        )
    }()
    
    private lazy var backgroundSplashWindow: UIWindow = {
        var splashVC = createSplashVC(logoIsHidden: true)
        
        return splashWindow(
            level: .normal - 1,
            rootViewController: splashVC
        )
    }()
    
    private func createSplashVC(logoIsHidden: Bool) -> SplashViewController {
        let splashVC = SplashViewController(
            nibName: String(describing: SplashViewController.self),
            bundle: nil
        )
        splashVC.logoIsHidden = logoIsHidden
        
        return splashVC
    }
    
    private func splashWindow(
        level: UIWindow.Level,
        rootViewController: SplashViewController
    ) -> UIWindow {
        let splashWindow = UIWindow()
        splashWindow.windowLevel = level
        splashWindow.rootViewController = rootViewController
        
        return splashWindow
    }
}

// MARK: - ISplashPresenter

extension SplashPresenter: ISplashPresenter {
    
    func present() {
        animator.animateAppearance()
    }
    
    func dismiss(completion: (() -> Void)?) {
        animator.animateDisappearance(completion: completion)
    }
}
