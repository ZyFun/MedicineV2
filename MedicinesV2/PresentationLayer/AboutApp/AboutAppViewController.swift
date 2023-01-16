//
//  AboutAppViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 16.01.2023.
//

import UIKit

class AboutAppViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: - Public property
    
    var presenter: AboutAppPresenter?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.presentAppVersion()
    }

    // MARK: - IBActions
    
    @IBAction func closeButtonPressed() {
        presenter?.view.dismiss()
    }
}

extension AboutAppViewController: AboutAppOutput {
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func setVersion(_ version: String) {
        versionLabel.text = version
    }
}
