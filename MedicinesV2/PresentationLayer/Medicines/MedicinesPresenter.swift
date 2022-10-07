//
//  MedicinesPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

/// Протокол логики презентации данных
protocol MedicinesPresentationLogiс: AnyObject {
    /// Метод для отображения плейсхолдера
    /// - Показывает его, если список лекарств пустой
    func showPlaceholder()
    /// Метод для скрытия плейсхолдера
    /// - Скрывает его, если список лекарств не пустой
    func hidePlaceholder()
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
    /// - Обновление происходит в глобальном потоке через 1 секунду после срабатывания метода.
    ///   Это необходимо для того, чтобы данные в базе успели обновится и я получил новые данные.
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
        interactor?.updatePlaceholder(for: currentFirstAidKit)
    }
    
    func updatePlaceholder() {
        // TODO: (#Update) Сделать скрытие плейсхолдера после добавления лекарства, а не после нажатия на +
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
    
    func hidePlaceholder() {
        view?.hidePlaceholder()
    }
    
    func showPlaceholder() {
        view?.showPlaceholder()
    }
}
