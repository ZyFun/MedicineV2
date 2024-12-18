//
//  FirstAidKitsFetchedResultsManager.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.09.2022.
//

import UIKit
import CoreData
import DTLogger

protocol IFirstAidKitsFetchedResultsManager {
    /// Используется для передачи таблицы с вью в FetchedResultsManager
    var tableView: UITableView? { get set }
    /// Используется для связи с DataSourceProvider
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> { get set }
	/// Используется для обновления плейсхолдера после обновления таблицы через NSFetchedResultsControllerDelegate
	/// - warning: Возможно нарушение архитектуры но хз как по другому.
	/// - note: Это необходимо для того, чтобы при получении данных из icloud
	/// в пустое приложение, происходило обновление плейсхолдера
	var presenter: FirstAidKitsPresentationLogic? { get set }
}

final class FirstAidKitsFetchedResultsManager: NSObject,
                                               IFirstAidKitsFetchedResultsManager {
    weak var tableView: UITableView?
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    // MARK: - Dependencies
    
	var presenter: FirstAidKitsPresentationLogic?
    let logger: DTLogger
    
    // MARK: - Initializer
    
    init(
        fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>,
        logger: DTLogger
    ) {
        self.fetchedResultsController = fetchedResultsController
        self.logger = logger
        super.init()
        self.fetchedResultsController.delegate = self
    }
	
	private func checkDataIsEmpty() {
		guard let objects = fetchedResultsController.fetchedObjects else { return }
		if objects.isEmpty {
			presenter?.showPlaceholder()
		} else {
			presenter?.hidePlaceholder()
		}
	}
    
    /// Метод для поиска просроченных лекарств в аптечке
    /// - Parameter currentFirstAidKid: аптечка в которой производится поиск
    /// - Returns: возвращает число просроченных лекарств
    /// - Такой же метод есть в `FirstAidKitsDataSourceProvider`
    private func searchExpiredMedicines(for currentFirstAidKid: DBFirstAidKit?) -> Int {
        // TODO: (MED-170) Логику ниже делать методом сервиса кордаты
        // к примеру назвать fetchCountExpiredMedicines
        var expiredMedicinesCount = 0
        
        // Этот код добавить для универсальности метода в кордате по задаче 170
        // чтобы если я работаю не в текущей аптечке, просто получать все
        // лекарства из базы
//        switch currentFirstAidKid {
//        case .none:
//            <#code#>
//        case .some(_):
//            <#code#>
//        }
        
        currentFirstAidKid?.medicines?.forEach { medicine in
            guard let medicine = medicine as? DBMedicine else { return }
            
            if let expiryDate = medicine.expiryDate, Date() >= expiryDate {
                expiredMedicinesCount += 1
            }
        }
        
        return expiredMedicinesCount
    }
}

extension FirstAidKitsFetchedResultsManager: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView?.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                tableView?.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let firstAidKit = fetchedResultsController.object(at: indexPath) as? DBFirstAidKit
                let cell = tableView?.cellForRow(at: indexPath) as? FirstAidKitCell
                
                let expiredCount = searchExpiredMedicines(for: firstAidKit)
                
                cell?.configure(
                    name: firstAidKit?.title ?? "",
                    expiredAmount: expiredCount,
                    amount: firstAidKit?.medicines?.count
                )
            }
        @unknown default:
            logger.log(.error, "Что то пошло не так в NSFetchedResultsControllerDelegate")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
		checkDataIsEmpty()
    }
}
