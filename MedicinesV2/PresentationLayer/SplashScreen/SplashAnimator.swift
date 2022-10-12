//
//  SplashAnimator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.10.2022.
//

import UIKit

protocol ISplashAnimator {
    func animateAppearance()
    func animateDisappearance(completion: (() -> Void)?)
}

final class SplashAnimator {
    
    // MARK: - Private properties
    
    private unowned let foregroundSplashWindow: UIWindow
    private unowned let foregroundSplashVC: SplashViewController
    
    // MARK: - Initializer
    
    init(foregroundSplashWindow: UIWindow) {
        self.foregroundSplashWindow = foregroundSplashWindow
        guard let foregroundSplashVC = foregroundSplashWindow
            .rootViewController as? SplashViewController else { fatalError() }
        
        self.foregroundSplashVC = foregroundSplashVC
    }
}

// MARK: - ISplashAnimator

extension SplashAnimator: ISplashAnimator {
    
    func animateAppearance() {
        foregroundSplashWindow.isHidden = false
        
        // Смещаю текст вниз, чтобы анимировано поднять в блоке анимации
        foregroundSplashVC.loadInformLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.3) {
            // Поднимаю текст обратно
            self.foregroundSplashVC.loadInformLabel.transform = .identity
            self.foregroundSplashVC.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        foregroundSplashVC.loadInformLabel.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.foregroundSplashVC.loadInformLabel.alpha = 1
        }
    }
    
    func animateDisappearance(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3) {
            self.foregroundSplashWindow.alpha = 0
        } completion: { _ in
            completion?()
        }
    }
}
