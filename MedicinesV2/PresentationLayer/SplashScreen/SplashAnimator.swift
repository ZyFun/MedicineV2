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
    
    private unowned let backgroundSplashWindow: UIWindow
    private unowned let backgroundSplashVC: SplashViewController
    
    private unowned let foregroundSplashWindow: UIWindow
    private unowned let foregroundSplashVC: SplashViewController
    
    // MARK: - Initializer
    
    init(
        foregroundSplashWindow: UIWindow,
        backgroundSplashWindow: UIWindow
    ) {
        self.foregroundSplashWindow = foregroundSplashWindow
        self.backgroundSplashWindow = backgroundSplashWindow
        
        guard let foregroundSplashVC = foregroundSplashWindow
            .rootViewController as? SplashViewController,
              
              let backgroundSplashVC = backgroundSplashWindow
            .rootViewController as? SplashViewController
        else {
            fatalError("splash window does not have root view controller")
        }
        
        self.foregroundSplashVC = foregroundSplashVC
        self.backgroundSplashVC = backgroundSplashVC
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
            self.foregroundSplashVC.logoImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        
        foregroundSplashVC.loadInformLabel.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.foregroundSplashVC.loadInformLabel.alpha = 1
        }
    }
    
    func animateDisappearance(completion: (() -> Void)?) {
        guard let window = UIApplication.shared.delegate?.window,
              let mainWindow = window else {
            fatalError("App Delegate does not have a window")
        }
        
        foregroundSplashWindow.alpha = 0
        backgroundSplashWindow.isHidden = false
        
        let logoImage = SplashViewController.logoImage
        let mask = CALayer()
        mask.contents = logoImage?.cgImage
        mask.frame = foregroundSplashVC.logoImageView.frame
        mainWindow.layer.mask = mask
        
        let maskImageView = UIImageView(image: logoImage)
        maskImageView.frame = mask.frame
        mainWindow.addSubview(maskImageView)
        mainWindow.bringSubviewToFront(maskImageView)
        
        // Так как не все анимации выполняются через CABasicAnimation,
        // использую это вместо группы.
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }
        
        mainWindow.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        UIView.animate(withDuration: 0.6) {
            mainWindow.transform = .identity
        }
        
        [mask, maskImageView.layer].forEach {
            addRotationAnimation(to: $0, duration: 0.6)
            addScalingAnimation(to: $0, duration: 0.6)
        }

        UIView.animate(withDuration: 0.2, delay: 0.1) {
            maskImageView.alpha = 0
        } completion: { _ in
            maskImageView.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundSplashVC.loadInformLabel.alpha = 0
        }
        
        CATransaction.commit()
    }
    
    private func addRotationAnimation(to layer: CALayer, duration: TimeInterval) {
        let animation = CABasicAnimation()
        
        let tangent = layer.position.y / layer.position.y
        let angle = atan(tangent)
        
        animation.beginTime = CACurrentMediaTime()
        animation.duration = duration
        animation.valueFunction = CAValueFunction(name: .rotateZ)
        animation.fromValue = 0
        animation.toValue = angle
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        layer.add(animation, forKey: "transform")
    }
    
    private func addScalingAnimation(to layer: CALayer, duration: TimeInterval) {
        let animation = CAKeyframeAnimation(keyPath: "bounds")
        let width = layer.frame.width
        let height = layer.frame.height
        let ratio: CGFloat = 18 / 667
        let finalScale = ratio * UIScreen.main.bounds.height
        let scales: [CGFloat] = [1, 0.85, finalScale]
        
        animation.beginTime = CACurrentMediaTime()
        animation.duration = duration
        animation.values = scales.map {
            NSValue(cgRect: CGRect(
                x: 0, y: 0, width: width * $0, height: height * $0)
            )
        }
        animation.timingFunctions = [
            CAMediaTimingFunction(name: .easeInEaseOut),
            CAMediaTimingFunction(name: .easeOut)
        ]
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        layer.add(animation, forKey: "bounds")
    }
}
