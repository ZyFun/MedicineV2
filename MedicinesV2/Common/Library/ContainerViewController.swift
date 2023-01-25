//
//  ContainerViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 25.01.2023.
//

import UIKit

final class ContainerViewController: UIViewController {
    private let rootView: UIView
    
    init(rootView: UIView) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
}
