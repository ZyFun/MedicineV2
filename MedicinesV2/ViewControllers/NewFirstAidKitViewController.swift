//
//  NewFirstAidKitViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 08.11.2021.
//
// TODO: Это предварительный код. По хорошему, нужно сделать добавление данных через alertController, так как поле всего одно

import UIKit

class NewFirstAidKitViewController: UIViewController {

    var newAidKit: [FirstAidKit] = []
    
    @IBOutlet weak var newAidKitTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func saveNewAidKit() {
        guard let firstAidKit = newAidKitTextField.text else { return }
        
        StorageManager.shared.saveData(firstAidKit) { firstAidKit in
            newAidKit.append(firstAidKit)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
