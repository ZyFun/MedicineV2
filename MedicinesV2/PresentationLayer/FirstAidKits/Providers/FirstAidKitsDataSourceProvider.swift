//
//  FirstAidKitsDataSourceProvider.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.09.2022.
//

import UIKit

protocol IFirstAidKitsDataSourceProvider: UITableViewDelegate, UITableViewDataSource {
    
    var fetchedResultManager: IFirstAidKitsFetchedResultsManager { get set }
}

final class FirstAidKitsDataSourceProvider: NSObject, IFirstAidKitsDataSourceProvider {
    
    // MARK: - Public Properties
    
    var fetchedResultManager: IFirstAidKitsFetchedResultsManager
    
    // MARK: - Private properties
    
    private let presenter: FirstAidKitsViewControllerOutput?
    
    // MARK: - Initializer
    
    init(
        presenter: FirstAidKitsViewControllerOutput?,
        resultManager: IFirstAidKitsFetchedResultsManager
    ) {
        self.presenter = presenter
        self.fetchedResultManager = resultManager
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
            Logger.error("Ошибка каста object к DBFirstAidKit")
            return nil
        }
        
        return firstAidKit
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
        
        cell.configure(
            titleFirstAidKit: firstAidKit.title,
            amountMedicines: String(currentAmountMedicines ?? 0)
        )
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        
        if editingStyle == .delete {
            guard let firstAidKit = fetchFirstAidKit(at: indexPath) else { return }
            presenter?.delete(firstAidKit)
        }
    }
}

// MARK: - Table view delegate

extension FirstAidKitsDataSourceProvider: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let currentFirstAidKit = fetchFirstAidKit(at: indexPath) else { return }
        presenter?.routeToMedicines(with: currentFirstAidKit)
    }
    
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        guard let firstAidKit = fetchFirstAidKit(at: indexPath) else { return nil }
        
        let editAction = UIContextualAction(
            style: .normal,
            title: "Изменить"
        ) { [weak self] _, _, isDone in
            
            self?.presenter?.showAlert(for: firstAidKit, by: indexPath)
            
            // Возвращаем значение в убегающее замыкание,
            // чтобы отпустить интерфейс при пользовательских действиях с ячейкой
            isDone(true)
        }
        
        // Настройка конпок действий
        editAction.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}