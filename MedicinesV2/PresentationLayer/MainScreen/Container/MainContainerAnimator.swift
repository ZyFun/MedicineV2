//
//  MainContainerAnimator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 13.01.2023.
//

import UIKit

protocol IMainContainerAnimator {
    func animateAppearance()
    func animateDisappearance()
}

final class MainContainerAnimator {
    
    // MARK: - Private properties
    
    private let mainVC: UIViewController
    
    private lazy var overlayView: UIView = {
        let view = UIView(frame: mainVC.view.bounds)
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.alpha = 0
        return view
    }()
    
    // MARK: - Initializer
    
    init(mainVC: UIViewController) {
        self.mainVC = mainVC
        
        mainVC.view.addSubview(overlayView)
    }
}

// MARK: - IMainContainerAnimator

extension MainContainerAnimator: IMainContainerAnimator {
    
    /// Анимация отображения меню
    func animateAppearance() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseInOut
        ) { [weak self] in
            guard let self else { return }
            let mainVCWidth = self.mainVC.view.frame.width * 2 / 3
            self.mainVC.view.frame.origin.x = mainVCWidth
            overlayView.alpha = 1
        }
    }
    
    /// Анимация скрытия меню
    func animateDisappearance() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: .curveEaseInOut
        ) { [weak self] in
            guard let self else { return }
            self.mainVC.view.frame.origin.x = 0
            overlayView.alpha = 0
        }
    }
}
