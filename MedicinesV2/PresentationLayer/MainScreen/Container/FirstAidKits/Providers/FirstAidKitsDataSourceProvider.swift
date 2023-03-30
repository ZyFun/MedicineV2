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
            SystemLogger.error("Ошибка каста object к DBFirstAidKit")
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
            titleFirstAidKit: firstAidKit.title,
            amountMedicines: String(currentAmountMedicines ?? 0),
            expiredCount: expiredCount
        )
        
        return cell
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
            
            // Возвращаем значение в убегающее замыкание,
            // чтобы отпустить интерфейс при пользовательских действиях с ячейкой
            isDone(true)
        }
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium, scale: .large)
        let editColor = #colorLiteral(red: 0.8705882353, green: 0.7843137255, blue: 0.5568627451, alpha: 1)
        editAction.backgroundColor = .systemGray6
        editAction.image = UIImage(
            systemName: "pencil",
            withConfiguration: largeConfig
        )?.withTintColor(
            .white,
            renderingMode: .alwaysTemplate
        ).addBackgroundCircle(color: editColor, diameter: 35)
        
        let deleteColor = #colorLiteral(red: 0.8729341626, green: 0.4694843888, blue: 0.5979845524, alpha: 1)
        deleteAction.backgroundColor = .systemGray6
        deleteAction.image = UIImage(
            systemName: "trash",
            withConfiguration: largeConfig
        )?.withTintColor(
            .white,
            renderingMode: .alwaysTemplate
        ).addBackgroundCircle(color: deleteColor, diameter: 35)
        
        let configuration = UISwipeActionsConfiguration(
            actions: [deleteAction, editAction]
        )
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}
