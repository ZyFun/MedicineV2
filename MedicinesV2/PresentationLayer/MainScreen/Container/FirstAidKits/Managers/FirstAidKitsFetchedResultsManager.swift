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
                    titleFirstAidKit: firstAidKit?.title,
                    amountMedicines: String(firstAidKit?.medicines?.count ?? 0),
                    expiredCount: expiredCount
                )
            }
        @unknown default:
            SystemLogger.error("Что то пошло не так в NSFetchedResultsControllerDelegate")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}
