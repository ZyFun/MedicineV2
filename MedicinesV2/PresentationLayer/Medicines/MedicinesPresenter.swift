//
//  MedicinesPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

/// Протокол логики презентации данных
protocol MedicinesPresentationLogiс: AnyObject {
    
}

/// Протокол взаимодействия ViewController-a с презенетром
protocol MedicinesViewControllerOutput {
    /// Метод для обновления состояния плейсхолдера
    /// - Используется для скрытия или отображения плейсхолдера
    /// - Если в базе аптечки есть лекарства, скрывается, иначе - отображается
    /// - Parameter currentFirstAidKit: принимает текущую аптечку, в которой будет работа
    ///                                 с плейсхолдером.
    func updatePlaceholder(for currentFirstAidKit: DBFirstAidKit?)
    /// Метод для обновления состояния плейсхолдера
    /// - Используется для скрытия плейсхолдера при нажатии на добавить лекарство
    func updatePlaceholder()
    /// Метод для обновления значка уведомлений на иконке приложения
    func updateNotificationBadge()
    /// Метод для удаления данных из БД
    /// - Parameter medicine: принимает лекарство, которое необходимо удалить из БД
    func delete(_ medicine: DBMedicine)
    /// Метод для перехода к конкретному лекарству, или созданию нового
    /// с передачей текущей аптечки, для привязки лекарства к ней.
    /// - Parameters:
    ///   - currentFirstAidKit: принимает текущую аптечку, для привязки к ней лекарства
    ///   - currentMedicine: принимает текущее лекарство, для его редактирования.
    ///   Если оно nil, то будет создано новое лекарство
    func routeToMedicine(with currentFirstAidKit: DBFirstAidKit?, by currentMedicine: DBMedicine?)
}

final class MedicinesPresenter {
    
    weak var view: MedicinesDisplayLogic?
    var interactor: MedicinesBusinessLogic?
    var router: MedicinesRouter?
}

extension MedicinesPresenter: MedicinesViewControllerOutput {
    func updatePlaceholder(for currentFirstAidKit: DBFirstAidKit?) {
        // TODO: (#MED-142) Придумать, как работать с многопоточкой и обновить плейсхолдер
        // Сейчас не совсем оптимально. Нужно обновлять, сразу после того как произошло обновление и делать это плавно с анимацией.
        if currentFirstAidKit?.medicines?.count != .zero {
            self.view?.hidePlaceholder()
        } else {
            self.view?.showPlaceholder()
        }
    }
    
    func updatePlaceholder() {
        // TODO: (#MED-142) Придумать, как работать с многопоточкой и обновить плейсхолдер
        // Сейчас не совсем оптимально. Нужно обновлять, сразу после того как произошло обновление и делать это плавно с анимацией.
        view?.hidePlaceholder()
    }
    
    func updateNotificationBadge() {
        interactor?.updateNotificationBadge()
    }
    
    func delete(_ medicine: DBMedicine) {
        interactor?.delete(medicine: medicine)
    }
    
    func routeToMedicine(with currentFirstAidKit: DBFirstAidKit?, by currentMedicine: DBMedicine?) {
        router?.routeTo(target: .medicine(currentFirstAidKit, currentMedicine))
    }
}

extension MedicinesPresenter: MedicinesPresentationLogiс {
    
}
