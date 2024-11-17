//
//  FirstAidKitsDataSourceProvider.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.09.2022.
//

import UIKit
import DTLogger

protocol IFirstAidKitsDataSourceProvider: UITableViewDelegate, UITableViewDataSource {
    
    var fetchedResultManager: IFirstAidKitsFetchedResultsManager { get set }
}

final class FirstAidKitsDataSourceProvider: NSObject, IFirstAidKitsDataSourceProvider {
    
    // MARK: - Public Properties
    
    var fetchedResultManager: IFirstAidKitsFetchedResultsManager
    var logger: DTLogger
    
    // MARK: - Private properties
    
    private let presenter: FirstAidKitsViewControllerOutput?

	private let generator = UINotificationFeedbackGenerator()

    // MARK: - Initializer
    
    init(
        presenter: FirstAidKitsViewControllerOutput?,
        resultManager: IFirstAidKitsFetchedResultsManager,
        logger: DTLogger
    ) {
        self.presenter = presenter
        self.fetchedResultManager = resultManager
        self.logger = logger
    }
    
    // MARK: - Private methods
    
    /// Метод для получения аптечки из fetchedResultsController
    /// - Parameter indexPath: принимает текущий индекс ячейки
    /// - Returns: возвращает аптечку либо nil
    /// - Возврат nil считать ошибкой, так как этого не должно происходить
    private func fetchFirstAidKit(at indexPath: IndexPath) -> DBFirstAidKit? {
        guard let firstAidKit = fetchedResultManager.fetchedResultsController.object(
            at: indexPath
        ) as? DBFirstAidKit else {
            logger.log(.error, "Ошибка каста object к DBFirstAidKit")
            return nil
        }
        
        return firstAidKit
    }
    
    /// Метод для поиска просроченных лекарств в аптечке
    /// - Parameter currentFirstAidKid: аптечка в которой производится поиск
    /// - Returns: возвращает число просроченных лекарств
    /// - Такой же метод есть в `FirstAidKitsFetchedResultsManager`
    private func searchExpiredMedicines(for currentFirstAidKid: DBFirstAidKit?) -> Int {
        // TODO: (MED-170) Логику ниже делать методом сервиса кордаты
        // к примеру назвать fetchCountExpiredMedicines
        var expiredMedicinesCount = 0
        
        currentFirstAidKid?.medicines?.forEach { medicine in
            guard let medicine = medicine as? DBMedicine else { return }
            
            if let expiryDate = medicine.expiryDate, Date() >= expiryDate {
                expiredMedicinesCount += 1
            }
        }
        
        return expiredMedicinesCount
    }
}

// MARK: - Table view data source

extension FirstAidKitsDataSourceProvider: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
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
            withIdentifier: String(describing: FirstAidKitCell.self),
            for: indexPath
        ) as? FirstAidKitCell else { return UITableViewCell() }
        
        guard let firstAidKit = fetchFirstAidKit(at: indexPath) else {
            return UITableViewCell()
        }
        
        let currentAmountMedicines = firstAidKit.medicines?.count
        
        let expiredCount = searchExpiredMedicines(for: firstAidKit)
        
        cell.configure(
            name: firstAidKit.title ?? "",
            expiredAmount: expiredCount,
            amount: currentAmountMedicines
        )
        
        cell.buttonTappedAction = { [weak self] in
            self?.presenter?.routeToMedicines(with: firstAidKit)
        }
        
        return cell
    }
    
}

// MARK: - Table view delegate

extension FirstAidKitsDataSourceProvider: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        guard let firstAidKit = fetchFirstAidKit(at: indexPath) else { return nil }
        
        let editAction = UIContextualAction(
            style: .normal,
            title: ""
        ) { [weak self] _, _, isDone in
            
            self?.presenter?.showAlert(for: firstAidKit, by: indexPath)
            
            // Возвращаем значение в убегающее замыкание,
            // чтобы отпустить интерфейс при пользовательских действиях с ячейкой
            isDone(true)
        }
        
        let deleteAction = UIContextualAction(
            style: .normal,
            title: ""
        ) { [weak self] _, _, isDone in
            self?.presenter?.delete(firstAidKit)
			self?.generator.notificationOccurred(.success)

            // Возвращаем значение в убегающее замыкание,
            // чтобы отпустить интерфейс при пользовательских действиях с ячейкой
            isDone(true)
        }
        
        editAction.backgroundColor = .systemGray6
        editAction.image = SystemIcons.editIcon.roundIconRendering(
            color: Colors.ripeWheat,
            diameter: Constants.diameterActionButton
        )
        
        deleteAction.backgroundColor = .systemGray6
        deleteAction.image = SystemIcons.deleteIcon.roundIconRendering(
            color: Colors.pinkRed,
            diameter: Constants.diameterActionButton
        )
        
        let configuration = UISwipeActionsConfiguration(
            actions: [deleteAction, editAction]
        )
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}

// MARK: - Constants

private extension FirstAidKitsDataSourceProvider {
    struct Constants {
        static let diameterActionButton: Double = 38
    }
}
