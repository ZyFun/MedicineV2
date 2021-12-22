//
//  FirstAidKitsConfigurator.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import UIKit

final class FirstAidKitsConfigurator {
    func config(view: UIViewController, navigationController: UINavigationController) {
        guard let view = view as? FirstAidKitsController else { return }
        
        let presenter = FirstAidKitsPresenter()
        let interactor = FirstAidKitInteractor()
        let router = FirstAidKitRouter(withNavigationController: navigationController)
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        
    }
}
