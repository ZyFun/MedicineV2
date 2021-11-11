//
//  MedicinesViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

class MedicinesViewController: UIViewController {
    
    // MARK: Public properties
    /// Ссылка на presenter
    var presenter: MedicinesPresenter?
    
    // MARK: ViewModels
    private var viewModels: [String] = [] {
        didSet {
            medicinesTableView?.reloadData()
        }
    }

    // MARK: IBOutlets
    @IBOutlet weak var medicinesTableView: UITableView? // держим опционалом, чтобы не было крита в случае отсутствия данных
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupXibs()
        setupTableView()
        
        // TODO: Разобраться, почему при вызове до появления вью, название не отображается
        presenter?.requestData()
    }
    
// МОжно писать тут, но сейчас в этом нет необходимости
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        presenter?.requestData()
//    }
    
    func display(_ viewModels: [String]) {
        self.viewModels = viewModels
    }

}

// MARK: - Конфигурирование ViewController
private extension MedicinesViewController {
    func setupTableView() {
        medicinesTableView?.delegate = self
        medicinesTableView?.dataSource = self
        
        // TODO: Загружать сюда название аптечки
        title = "Название аптечки"
        
        // MARK: Актуально для iOS ниже 15 версии. Можно удалить после прекращения поддержки этих версий
        medicinesTableView?.tableFooterView = UIView()
    }
    
    ///Инициализация Xibs
    func setupXibs() {
        medicinesTableView?.register(UINib(nibName: String(describing: MedicineTableViewCell.self), bundle: nil),
                                    forCellReuseIdentifier: String(describing: MedicineTableViewCell.self))
    }

}

// MARK: - UITableViewDelegate
extension MedicinesViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension MedicinesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MedicineTableViewCell.self), for: indexPath) as! MedicineTableViewCell
        
        cell.configure(text: viewModels[indexPath.row])
        
        return cell
    }
}


