//
//  FirstAidKitsController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import UIKit

/// Протокол отображения FirstAidKitController-а
protocol FirstAidKitsDisplayLogic: AnyObject {
    /// Метод передаёт данные в модель данных
    func display(_ viewModels: FirstAidKit?)
}

class FirstAidKitsController: UIViewController {
    
    // MARK: Public properties
    /// Ссылка на presenter
    var presenter: FirstAidKitsViewControllerOutput?
    
    // MARK: Outlets
    @IBOutlet weak var firstAidKitsTableView: UITableView!
    
    // MARK: Private properties
    private var viewModel: FirstAidKit?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}
// MARK: - Конфигурирование ViewController
extension FirstAidKitsController {
    /// Метод инициализации VC
    func setup() {
        setupNavigationBar()
        setupTableView()
        setupXib()
    }
    
    /// Метод настройки Navigation Bar
    func setupNavigationBar() {
        // TODO: Произвести настройку
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Аптечки"
    }
    
    /// Метод настройки таблицы
    func setupTableView() {
        firstAidKitsTableView.delegate = self
        firstAidKitsTableView.dataSource = self
    }
    
    /// Инициализация Xibs
    func setupXib() {
        // Регистрируем ячейку для таблицы аптечек
        firstAidKitsTableView.register(
            UINib(
                nibName: String(describing: FirstAidKitTableViewCell.self),
                bundle: nil
            ),
            forCellReuseIdentifier: String(describing: FirstAidKitTableViewCell.self)
        )
    }
}

// MARK: - Table view data source
extension FirstAidKitsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FirstAidKitTableViewCell.self), for: indexPath) as! FirstAidKitTableViewCell
        
        cell.accessoryType = .disclosureIndicator
        cell.configure(titleFirstAidKit: "Test", amountMedicines: "1")
        
        return cell
    }
}

// MARK: - Table view delegate
extension FirstAidKitsController: UITableViewDelegate {
    
}

// MARK: - Логика обновления данных View
extension FirstAidKitsController: FirstAidKitsDisplayLogic {
    func display(_ viewModels: FirstAidKit?) {
        viewModel = viewModels
    }
}
