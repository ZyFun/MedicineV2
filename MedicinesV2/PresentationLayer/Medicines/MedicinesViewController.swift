//
//  MedicinesViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

/// Протокол отображения ViewCintroller-a
protocol DisplayLogic: AnyObject {
    
}

final class MedicinesViewController: UIViewController {
    
    // MARK: Public properties
    /// Ссылка на presenter
    var presenter: MedicinesViewControllerOutput?
    var fetchedResultManager: IMedicinesFetchedResultsManager?
    /// Содержит в себе выбранную аптечку, для её связи с лекарствами
    var currentFirstAidKit: DBFirstAidKit?

    // MARK: IBOutlets
    /// Таблица с лекарствами
    @IBOutlet weak var medicinesTableView: UITableView? // держим опционалом, чтобы не было крита в случае отсутствия данных
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // FIXME: Сейчас служит только для обновления центра уведомлений, переделать
        presenter?.requestData()
    }
}

// MARK: - Конфигурирование ViewController
private extension MedicinesViewController {
    
    /// Метод инициализации VC
    func setup() {
        setupNavigationBar()
        setupTableView()
        setupXibs()
    }
    
    // MARK: Setup table view
    /// Метод настройки таблицы
    func setupTableView() {
        medicinesTableView?.delegate = self
        medicinesTableView?.dataSource = self
        
        fetchedResultManager?.tableView = medicinesTableView
        
        // MARK: Актуально для iOS ниже 15 версии. Можно удалить после прекращения поддержки этих версий
        medicinesTableView?.tableFooterView = UIView()
        
        setupXibs()
    }
    
    ///Инициализация Xibs
    func setupXibs() {
        medicinesTableView?.register(
            UINib(
                nibName: String(describing: MedicineTableViewCell.self),
                bundle: nil
            ),
            forCellReuseIdentifier: String(describing: MedicineTableViewCell.self)
        )
    }
    
    // MARK: Setup navigation bar
    /// Метод настройки Navigation Bar
    func setupNavigationBar() {
        title = currentFirstAidKit?.title
        addButtons()
    }
    
    /// Добавление кнопок в navigation bar
    func addButtons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMedicine))
        navigationItem.rightBarButtonItems = [addButton]
    }
    
    // MARK: Actions
    /// Добавление нового лекарства
    @objc func addNewMedicine() {
        presenter?.routeToMedicine(with: currentFirstAidKit, by: nil)
    }
    

}

// MARK: - Логика обновления данных View
extension MedicinesViewController: DisplayLogic {
    func display(_ viewModels: [DBMedicine]) {
        
    }
}

// MARK: - UITableViewDelegate
extension MedicinesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentMedicine = fetchedResultManager?.fetchedResultsController.object(
            at: indexPath
        ) as? DBMedicine else {
            Logger.error("Ошибка каста object к DBMedicine")
            return
        }
        presenter?.routeToMedicine(with: currentFirstAidKit, by: currentMedicine)
    }
}

// MARK: - UITableViewDataSource
extension MedicinesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultManager?.fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MedicineTableViewCell.self), for: indexPath) as? MedicineTableViewCell else { return UITableViewCell() }
        
        guard let medicine = fetchedResultManager?.fetchedResultsController.object(
            at: indexPath
        ) as? DBMedicine else {
            Logger.error("Ошибка каста object к DBMedicine")
            return UITableViewCell()
        }
        
        cell.configure(
            name: medicine.title ?? "",
            type: medicine.type ?? "",
            expiryDate: medicine.expiryDate?.toString() ?? "",
            amount: "\(medicine.amount ?? 0)"
        )
        
        // TODO: Все вычисления нужно вынести в другое место, а не писать это в вызове ячеек. Например в конфигурировании ячейки создать параметр принимающий булево значение и функцию с рассчетом, которая будет возвращать его в эту ячейку, по умолчанию информация о просрочек должна быть скрытой.
        // Показываем иконку просроченного лекарства, если не просрочено и не указана дата, оставляем иконку скрытой
        if Date() >= medicine.expiryDate ?? Date() {
            cell.configureAlertLabel(
                title: "В мусор",
                isAlertLabelPresent: true
            )
        }
        
        // Показывает иконку о необходимости покупки лекарств
        if (medicine.amount as? Int ?? 0) <= 0 {
            cell.configureAlertLabel(
                title: "Купить",
                isAlertLabelPresent: true
            )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: После добавления уведомлений, не забыть добавить очистку очереди (посмотреть код из аналогичного метода старой версии)
            guard let medicine = fetchedResultManager?.fetchedResultsController.object(
                at: indexPath
            ) as? DBMedicine else {
                Logger.error("Ошибка каста object к DBMedicine")
                return
            }
            
            presenter?.delete(medicine)
        }
    }
}
