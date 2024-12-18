//
//  MedicinesFetchedResultsManager.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 20.09.2022.
//

import UIKit
import CoreData
import DTLogger

protocol IMedicinesFetchedResultsManager {
    /// Используется для передачи таблицы с вью в FetchedResultsManager
    var tableView: UITableView? { get set }
    /// Используется для связи с DataSourceProvider
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> { get set }
}

final class MedicinesFetchedResultsManager: NSObject,
                                            IMedicinesFetchedResultsManager {
    weak var tableView: UITableView?
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    // MARK: - Dependencies
    
    private let logger: DTLogger
    
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
}

extension MedicinesFetchedResultsManager: NSFetchedResultsControllerDelegate {
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
                let medicine = fetchedResultsController.object(at: indexPath) as? DBMedicine
                let cell = tableView?.cellForRow(at: indexPath) as? MedicineCell

                cell?.configure(
                    name: medicine?.title ?? "",
                    type: medicine?.type,
                    purpose: medicine?.purpose,
                    expiryDate: medicine?.expiryDate,
					amount: medicine?.amount,
					unitType: NSLocalizedString(medicine?.unitType ?? String(localized: "шт"), comment: "")
                )
            }
        @unknown default:
            logger.log(.error, "Что то пошло не так в NSFetchedResultsControllerDelegate")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}
