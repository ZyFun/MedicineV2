//
//  MedicinesDataSourceProvider.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 23.09.2022.
//

import UIKit
import DTLogger

protocol IMedicinesDataSourceProvider: UITableViewDelegate, UITableViewDataSource {
    var fetchedResultManager: IMedicinesFetchedResultsManager { get set }
}

final class MedicinesDataSourceProvider: NSObject, IMedicinesDataSourceProvider {
    
    // MARK: - Public Properties
    
    var fetchedResultManager: IMedicinesFetchedResultsManager
    
    // MARK: - Private properties
    
    private let presenter: MedicinesViewControllerOutput?
    private let currentFirstAidKit: DBFirstAidKit
    
    // MARK: - Dependencies
    
    private let logger: DTLogger
    
    // MARK: - Initializer
    
    init(
        presenter: MedicinesViewControllerOutput?,
        resultManager: IMedicinesFetchedResultsManager,
        currentFirstAidKit: DBFirstAidKit,
        logger: DTLogger
    ) {
        self.presenter = presenter
        self.fetchedResultManager = resultManager
        self.currentFirstAidKit = currentFirstAidKit
        self.logger = logger
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
            logger.log(.error, "Ошибка каста object к DBMedicine")
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
            withIdentifier: String(describing: MedicineCell2.self),
            for: indexPath
        ) as? MedicineCell2 else { return UITableViewCell() }
        
        let medicine = fetchMedicine(at: indexPath)
        
        cell.configure(
            name: medicine?.title ?? "",
            type: medicine?.type,
            purpose: medicine?.purpose,
            expiryDate: medicine?.expiryDate,
            amount: medicine?.amount
        )
        
        cell.buttonTappedAction = { [weak self] in
            self?.presenter?.routeToMedicine(with: self?.currentFirstAidKit, by: medicine)
        }
        
        return cell
    }
    
}

// MARK: - Table view delegate

extension MedicinesDataSourceProvider: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(
            style: .normal,
            title: ""
        ) { [weak self] _, _, isDone in
            
            guard let medicine = self?.fetchMedicine(at: indexPath) else { return }
            self?.presenter?.delete(medicine)
            
            // Возвращаем значение в убегающее замыкание,
            // чтобы отпустить интерфейс при пользовательских действиях с ячейкой
            isDone(true)
        }
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium, scale: .large)
        let deleteColor = #colorLiteral(red: 0.8729341626, green: 0.4694843888, blue: 0.5979845524, alpha: 1)
        deleteAction.image = UIImage(
            systemName: "trash",
            withConfiguration: largeConfig
        )?.withTintColor(
            .white,
            renderingMode: .alwaysTemplate
        ).addBackgroundCircle(color: deleteColor, diameter: 35)
        
        deleteAction.backgroundColor = .systemGray6
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}
