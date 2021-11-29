//
//  MedicinesViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

/// Логика отображения данных на вью
protocol DisplayLogic: AnyObject {
    func display(_ viewModels: [FirstAidKit])
}

class MedicinesViewController: UIViewController {
    
    // MARK: Public properties
    /// Ссылка на presenter
    var presenter: EventIntercepter?
    
    // TODO: Временное решение для тестирования, до момента создания всей БД.
    // MARK: Переданные данные с другого вью
    var titleFirstAidKit: String = ""
    
    // MARK: ViewModels
    private var viewModels: [FirstAidKit] = [] {
        didSet {
            medicinesTableView?.reloadData()
        }
    }

    // MARK: IBOutlets
    @IBOutlet weak var medicinesTableView: UITableView? // держим опционалом, чтобы не было крита в случае отсутствия данных
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        presenter?.requestData()
    }
    
// МОжно писать тут, но сейчас в этом нет необходимости
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        presenter?.requestData()
//    }

}

// MARK: - Конфигурирование ViewController
private extension MedicinesViewController {
    
    /// Метод инициализации VC
    func setup() {
        setupNavBar()
        setupTableView()
        setupXibs()
    }
    
    /// Метод настройки таблицы
    func setupTableView() {
        medicinesTableView?.delegate = self
        medicinesTableView?.dataSource = self
        
        // MARK: Актуально для iOS ниже 15 версии. Можно удалить после прекращения поддержки этих версий
        medicinesTableView?.tableFooterView = UIView()
        setupXibs()
    }
    
    /// Метод настройки Navigation Bar
    func setupNavBar() {
        // Возможно потребуется, когда вход в приложение будет без сториборда, если нет, удалить
//        navigationController?.navigationBar.prefersLargeTitles = true
        title = titleFirstAidKit
    }
    
    ///Инициализация Xibs
    func setupXibs() {
        medicinesTableView?.register(UINib(nibName: String(describing: MedicineTableViewCell.self), bundle: nil),
                                    forCellReuseIdentifier: String(describing: MedicineTableViewCell.self))
    }

}

// MARK: - Логика обновления данных View
extension MedicinesViewController: DisplayLogic {
    func display(_ viewModels: [FirstAidKit]) {
        self.viewModels = viewModels
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
        
        cell.configure(text: viewModels[indexPath.row].title ?? "")
        
        return cell
    }
}


