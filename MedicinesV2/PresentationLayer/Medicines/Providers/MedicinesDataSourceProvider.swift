//
//  MedicinesDataSourceProvider.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 23.09.2022.
//

import UIKit

protocol IMedicinesDataSourceProvider: UITableViewDelegate, UITableViewDataSource {
    var fetchedResultManager: IMedicinesFetchedResultsManager { get set }
}

final class MedicinesDataSourceProvider: NSObject, IMedicinesDataSourceProvider {
    
    // MARK: - Public Properties
    
    var fetchedResultManager: IMedicinesFetchedResultsManager
    
    // MARK: - Private properties
    
    private let presenter: MedicinesViewControllerOutput?
    private let currentFirstAidKit: DBFirstAidKit
    
    // MARK: - Initializer
    
    init(
        presenter: MedicinesViewControllerOutput?,
        resultManager: IMedicinesFetchedResultsManager,
        currentFirstAidKit: DBFirstAidKit
    ) {
        self.presenter = presenter
        self.fetchedResultManager = resultManager
        self.currentFirstAidKit = currentFirstAidKit
    }
    
    // MARK: - Private methods
    
    /// Метод для получения лекарства из fetchedResultsController
    /// - Parameter indexPath: принимает текущий индекс ячейки
    /// - Returns: возвращает аптечку либо nil
    /// - Возврат nil считать ошибкой, так как этого не должно происходить
    private func fetchMedicine(at indexPath: IndexPath) -> DBMedicine? {
        guard let medicine = fetchedResultManager.fetchedResultsController.object(
            at: indexPath
        ) as? DBMedicine else {
            CustomLogger.error("Ошибка каста object к DBMedicine")
            return nil
        }
        
        return medicine
    }
}

// MARK: - Table view data source

extension MedicinesDataSourceProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultManager.fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MedicineCell.self),
            for: indexPath
        ) as? MedicineCell else { return UITableViewCell() }
        
        guard let medicine = fetchMedicine(at: indexPath) else { return UITableViewCell() }
        
        cell.configure(
            name: medicine.title ?? "",
            type: medicine.type,
            expiryDate: medicine.expiryDate,
            amount: medicine.amount
        )
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        
        if editingStyle == .delete {
            guard let medicine = fetchMedicine(at: indexPath) else { return }
            presenter?.delete(medicine)
        }
    }
}

// MARK: - Table view delegate

extension MedicinesDataSourceProvider: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let currentMedicine = fetchMedicine(at: indexPath) else { return }
        presenter?.routeToMedicine(with: currentFirstAidKit, by: currentMedicine)
    }
}
