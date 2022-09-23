//
//  FirstAidKitsFetchedResultsManager.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 19.09.2022.
//

import UIKit
import CoreData

protocol IFirstAidKitsFetchedResultsManager {
    /// Используется для передачи таблицы с вью в FetchedResultsManager
    var tableView: UITableView? { get set }
    /// Используется для связи с DataSourceProvider
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> { get set }
}

final class FirstAidKitsFetchedResultsManager: NSObject,
                                               IFirstAidKitsFetchedResultsManager {
    weak var tableView: UITableView?
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    // MARK: - Initializer
    
    init(
        fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        self.fetchedResultsController = fetchedResultsController
        super.init()
        self.fetchedResultsController.delegate = self
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
                
                cell?.configure(
                    titleFirstAidKit: firstAidKit?.title,
                    amountMedicines: String(firstAidKit?.medicines?.count ?? 0)
                )
            }
        @unknown default:
            Logger.error("Что то пошло не так в NSFetchedResultsControllerDelegate")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}

