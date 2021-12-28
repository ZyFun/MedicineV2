//
//  FirstAidKitsInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import Foundation
import CoreData

protocol FirstAidKitsBusinessLogic {
    func requestData() -> NSFetchedResultsController<NSFetchRequestResult>
    
    func requestData(at indexPath: IndexPath) -> FirstAidKit
}

final class FirstAidKitInteractor {
    weak var presenter: FirstAidKitsPresentationLogic?
    
    var dataModel = StorageManager.shared.fetchedResultsController(
        entityName: "FirstAidKit",
        keyForSort: "title"
    )
}

extension FirstAidKitInteractor: FirstAidKitsBusinessLogic {
    func requestData() -> NSFetchedResultsController<NSFetchRequestResult> {
        // TODO: Должно быть обращение к презентеру
        dataModel
    }
    
    func requestData(at indexPath: IndexPath) -> FirstAidKit {
        dataModel.object(at: indexPath) as! FirstAidKit
    }
    
    // TODO: Извлеч данные в массив вот таким образом
    func dataArray() {
        let obgects = dataModel.fetchRequest
        
        do {
            let results = try dataModel.managedObjectContext.execute(obgects)
            let test = results as! [FirstAidKit]
            for result in results as! [FirstAidKit] {
                let data = result
            }
        } catch {
            print(error)
        }
    }
}
