//
//  MedicinesViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

/// Протокол отображения ViewCintroller-a
protocol DisplayLogic: AnyObject {
    /// Метод для передачи данных в модель данных
    func display(_ viewModels: [Medicine])
}

final class MedicinesViewController: UIViewController {
    
    // MARK: Public properties
    /// Ссылка на presenter
    var presenter: MedicinesViewControllerOutput?
    /// Содержит в себе выбранную аптечку, для её связи с лекарствами
    var currentFirstAidKit: FirstAidKit?
    
    // MARK: ViewModels
    /// Модель данных "Лекарство"
    /// - содержит в себе лекарства, отфильтрованные по текущей (выбранной) аптечке.
    private var viewModels: [Medicine]?

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

        presenter?.requestData()
        medicinesTableView?.reloadData()
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
    func display(_ viewModels: [Medicine]) {
        // Выполняем фильтрацию в зависимости от выбранной аптечки и отображаем связанныее с ней лекарства
        // TODO: Возможно логику подготовки к отображению и фильтрацию, стоит перенести в презентер
        self.viewModels = viewModels.filter({$0.firstAidKit == currentFirstAidKit})
    }
}

// MARK: - UITableViewDelegate
extension MedicinesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.routeToMedicine(with: currentFirstAidKit, by: viewModels?[indexPath.row])
    }
}

// MARK: - UITableViewDataSource
extension MedicinesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MedicineTableViewCell.self), for: indexPath) as? MedicineTableViewCell else { return UITableViewCell() }
        
        guard let medicine = viewModels?[indexPath.row] else { return UITableViewCell() }
        
        cell.configure(
            name: medicine.title ?? "",
            type: medicine.type ?? "",
            expiryDate: medicine.expiryDate?.toString() ?? "",
            amount: String(medicine.amount)
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
        if medicine.amount <= 0 {
            cell.configureAlertLabel(
                title: "Купить",
                isAlertLabelPresent: true
            )
        }
        
        return cell
    }
    
    // Удаление лекарства
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: После добавления уведомлений, не забыть добавить очистку очереди (посмотреть код из аналогичного метода старой версии)
            guard let medicine = viewModels?[indexPath.row] else { return }

            viewModels?.remove(at: indexPath.row)
            medicinesTableView?.deleteRows(at: [indexPath], with: .fade)
            presenter?.deleteData(medicine)
        }
    }
}
