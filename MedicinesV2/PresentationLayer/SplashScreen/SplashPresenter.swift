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
        foregroundSplashWindow: foregroundSplashWindow
    )
    
    private let splashVC = SplashViewController(
        nibName: String(describing: SplashViewController.self),
        bundle: nil
    )
    
    private lazy var foregroundSplashWindow: UIWindow = {
        let splashWindow = UIWindow()
        splashWindow.windowLevel = .normal + 1
        splashWindow.rootViewController = splashVC
        
        return splashWindow
    }()
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
