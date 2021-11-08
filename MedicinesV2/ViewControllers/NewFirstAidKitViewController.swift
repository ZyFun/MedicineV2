//
//  NewFirstAidKitViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 08.11.2021.
//
// TODO: Назад данные не возвращаются, но это и не нужно. Работа будет проходить с базой данных. Всё что написано, это предварительный код. ПО хорошему, нужно сделать добавление данных через alertController, так как поле всего одно

import UIKit

class NewFirstAidKitViewController: UIViewController {

    var newAidKit = [""]
    
    @IBOutlet weak var newAidKitTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func saveNewAidKit() {
        guard let firstAidKit = newAidKitTextField.text else { return }
        newAidKit.append(firstAidKit)
        navigationController?.popViewController(animated: true)
    }
}
