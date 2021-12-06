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
    var currentFirstAidKit: FirstAidKit?
    
    // MARK: ViewModels
    // TODO: На данный момент модель никак не обновляется, так как я не передаю с щругого экрана информацию о том, что модель обновилась
    private var viewModels: [Medicine]? {
        didSet {
            // TODO: Временно отключил этот способ обработки, так как в текущей реализации он только портит обновление данных. ВОзможно я просто удалю этот способ обновления таблицы и буду обновлять его в ручную. Либо нужно прописать в неё логику, которая будет отрабатывать на обновление в зависимости от ситуации
//            medicinesTableView?.reloadData()
        }
    }

    // MARK: IBOutlets
    @IBOutlet weak var medicinesTableView: UITableView? // держим опционалом, чтобы не было крита в случае отсутствия данных
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
//        presenter?.requestData()
    }
    
    // TODO: Временное решение, пока нет передачи информации о том, что добавились новые данные. Отслеживание должно быть чререз специальный контроллер базы данных, так как аптечку и прочее я буду удалять. Нужно подумать как это записать
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
        title = currentFirstAidKit?.title
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
        // Выполняем фильтрацию в зависимости от выбранной аптечки и отображаем связанныее с ней лекарства
        // TODO: Возможно логику подготовки к отображению и фильтрацию, стоит перенести в интерактор
        self.viewModels = viewModels.filter({$0.firstAidKit == currentFirstAidKit})
        
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
    
    // Удаление лекарства
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: После добавления уведомлений, не забыть добавить очистку очереди (посмотреть код из аналогичного метода старой версии)
            // TODO: Доработать в будущем на этот способ обработки удаления
//            let medicine = fetchedResultsController.object(at: indexPath) as! Medicine
            
            guard let medicine = viewModels?[indexPath.row] else { return }

            // TODO: Исправить после перехода с массивов на кордата контроллер. Так же тут всё нарушает архитектуру. Нужно доработать.
            viewModels?.remove(at: indexPath.row)
            medicinesTableView?.deleteRows(at: [indexPath], with: .fade)
            StorageManager.shared.deleteObject(medicine)
            
        }
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
        
        medicineVC.currentFirstAidKit = currentFirstAidKit
        navigationController?.pushViewController(medicineVC, animated: true)
    }
}
