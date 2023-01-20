//
//  AboutAppViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 16.01.2023.
//

import UIKit

/// Протокол отображения данных ViewCintroller-a
protocol AboutAppView: AnyObject {
    /// Метод установки описания информации о приложении
    /// - Parameter infoModel: принимает модель с собранной информацией о приложении
    func setAppInfo(from infoModel: AboutAppInfoModel)
    /// Метод для открытия URL в сафари
    /// - Parameter url: принимает необходимый URL адрес.
    func open(url: URL)
    /// Метод выхода с экрана
    func dismiss()
}

final class AboutAppViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var discordUrlLabel: UILabel!
    @IBOutlet weak var tgButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Public property
    
    var presenter: AboutAppPresenter?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        presenter?.presentAppInfo()
    }

    // MARK: - IBActions
    
    @IBAction func closeButtonPressed() {
        presenter?.view?.dismiss()
    }
    
    @IBAction func tgButtonPressed() {
        presenter?.openTGUrl()
    }
}

// MARK: - Логика обновления данных View

extension AboutAppViewController: AboutAppView {
    func setAppInfo(from infoModel: AboutAppInfoModel) {
        versionLabel.text = infoModel.version
        developerLabel.text = infoModel.developer
        discordUrlLabel.text = infoModel.discordUrl
    }
    
    func open(url: URL) {
        UIApplication.shared.open(url)
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}

// MARK: - Конфигурирование ViewController

private extension AboutAppViewController {
    func setup() {
        setupButtons()
    }
    
    func setupButtons() {
        tgButton.setTitle("Telegram", for: .normal)
        
        closeButton.layer.borderWidth = 1
        closeButton.layer.cornerRadius = 16
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.layer.borderColor = UIColor.systemGray.cgColor
    }
}
