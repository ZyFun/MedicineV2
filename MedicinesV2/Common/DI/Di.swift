//
//  Di.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 25.01.2023.
//

import UIKit

final class Di {
    fileprivate let screenFactory: ScreenFactory
    
    init() {
        screenFactory = ScreenFactory()
        screenFactory.di = self
    }
}

final class ScreenFactory {
    fileprivate weak var di: Di!
    fileprivate init() {}
    
    func makeSplashScreen() -> UIViewController {
        return ContainerViewController(rootView: UIView())
    }
    
}
