//
//  MedicinesViewController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import UIKit

/// Логика отображения данных на вью
protocol DisplayLogic: AnyObject {
    func display(_ viewModels: [Medicine])
}

class MedicinesViewController: UIViewController {
    
    // MARK: Public properties
    /// Ссылка на presenter
    var presenter: EventIntercepter?
    
    // TODO: Временное решение для тестирования, до момента создания всей БД.
    // MARK: Переданные данные с другого вью
    var titleFirstAidKit: String = ""
    
    // MARK: ViewModels
    // TODO: На данный момент модель никак не обновляется, так как я не передаю с щругого экрана информацию о том, что модель обновилась
    private var viewModels: [Medicine]? {
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
    
    // TODO: Временное решение, пока нет передачи информации о том, что добавились новые данные. Отслеживание должно быть чререз специальный контроллер базы данных, так как аптечку и прочее я буду удалять. Нужно подумать как это записать
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
        medicinesTableView?.register(UINib(nibName: String(describing: MedicineTableViewCell.self), bundle: nil),
                                    forCellReuseIdentifier: String(describing: MedicineTableViewCell.self))
    }
    
    /// Метод настройки Navigation Bar
    func setupNavigationBar() {
        // Возможно потребуется, когда вход в приложение будет без сториборда, если нет, удалить
//        navigationController?.navigationBar.prefersLargeTitles = true
        title = titleFirstAidKit
        addButtons()
    }
    
    /// Добавление кнопок в navigation bar
    func addButtons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMedicine))
        navigationItem.rightBarButtonItems = [addButton]
    }
    
    // MARK: Actions
    /// Сохранение всех данных лекарства
    @objc func addNewMedicine() {
        createMedicineVC(with: nil)
    }
    

}

// MARK: - Логика обновления данных View
extension MedicinesViewController: DisplayLogic {
    func display(_ viewModels: [Medicine]) {
        self.viewModels = viewModels
    }
}

// MARK: - UITableViewDelegate
extension MedicinesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createMedicineVC(with: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension MedicinesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MedicineTableViewCell.self), for: indexPath) as! MedicineTableViewCell
        
        cell.configure(text: viewModels?[indexPath.row].title ?? "")
        
        return cell
    }
}

// MARK: - Инициализация вью Medicine
extension MedicinesViewController {
    // TODO: Это должно быть в роутере, но пока что делаю здесь, чтобы не перегружать мозг. Доработаю при рефакторинге под viper
    
    func createMedicineVC(with indexPath: IndexPath?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let medicineVC = storyboard.instantiateViewController(withIdentifier: "medicine") as? MedicineTableViewController else { return }
        
        if let indexPath = indexPath {
            // Тут я передаю данные до появления роутера и прочих модулей вайпера
            let medicineName = viewModels?[indexPath.row]
            medicineVC.medicine = medicineName
        }
        
        navigationController?.pushViewController(medicineVC, animated: true)
    }
}
