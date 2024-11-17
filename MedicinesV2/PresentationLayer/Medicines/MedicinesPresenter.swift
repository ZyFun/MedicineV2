//
//  MedicinesPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation

protocol MedicinesPresenterDelegate: AnyObject {
	/// Метод для скрытия плейсхолдера
	/// - Скрывает его, после успешного сохранения лекарства
	func hidePlaceholder()
}

/// Протокол логики презентации данных
protocol MedicinesPresentationLogiс: AnyObject {
    /// Метод для отображения плейсхолдера
    /// - Показывает его, если список лекарств пустой
    func showPlaceholder()
}

/// Протокол взаимодействия ViewController-a с презенетром
/// - подписывается на протокол ``MedicinesPresenterDelegate`` для того, чтобы скрыть плейсхолдер,
/// в случае успешного сохранение лекарства.
protocol MedicinesViewControllerOutput: MedicinesPresenterDelegate {
    /// Метод для обновления состояния плейсхолдера
    /// - Используется для скрытия или отображения плейсхолдера
    /// - Если в базе аптечки есть лекарства, скрывается, иначе - отображается
    /// - Parameter currentFirstAidKit: принимает текущую аптечку, в которой будет работа
    ///                                 с плейсхолдером.
    func updatePlaceholder(for currentFirstAidKit: DBFirstAidKit?)
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
    func showPlaceholder() {
        view?.showPlaceholder()
    }
}

extension MedicinesPresenter: MedicinesPresenterDelegate {
	func hidePlaceholder() {
		view?.hidePlaceholder()
	}
}
