//
//  SplashViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 12.10.2022.
//

import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var loadInformLabel: UILabel!
    
    var logoIsHidden: Bool = false
    
    static let logoImage = UIImage(named: "AppLogo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.isHidden = logoIsHidden
    }
}
