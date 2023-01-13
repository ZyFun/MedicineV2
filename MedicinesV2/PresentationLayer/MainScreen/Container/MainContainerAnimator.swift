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
    
    // MARK: - Initializer
    
    init(mainVC: UIViewController) {
        self.mainVC = mainVC
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
        }
    }
}
