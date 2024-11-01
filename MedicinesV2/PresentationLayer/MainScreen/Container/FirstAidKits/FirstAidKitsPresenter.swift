//
//  FirstAidKitsPresenter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 22.12.2021.
//

import Foundation

/// Протокол логики презентации данных
protocol FirstAidKitsPresentationLogic: AnyObject {
    /// Метод для скрытия сплешскрина
    /// - Скрывает сплешскрин по окончанию загрузки всех данных и настройки приложения
    /// - на данный момент вызывается методом `updateAllNotifications` в интеракторе.
    func dismissSplashScreen()
    /// Метод для скрытия плейсхолдера
    /// - Скрывает его, если список аптечек не пустой
    func hidePlaceholder()
    /// Метод для отображения плейсхолдера
    /// - Показывает его, если список аптечек пустой
    func showPlaceholder()
    /// Метод для обновления лейбла о просроченных лекарствах в аптечке
    func updateExpiredMedicinesLabel()
}

/// Протокол взаимодействия ViewController-a с презенетром
protocol FirstAidKitsViewControllerOutput {
    /// Метод для обновления состояния плейсхолдера
    /// - Используется для скрытия или отображения плейсхолдера
    /// - Если в базе есть аптечки, скрывается, иначе - отображается
    func updatePlaceholder()
    /// Метод для поиска просроченных лекарств в аптечке
    /// - Используется для обновления лейбла в списке аптечек
    func searchExpiredMedicines()
    /// Метод для отображения кастомного алерт контроллера добавления или редактирования аптечки
    /// - Parameters:
    ///   - entity: Принимает аптечку
    ///   - index: принимает IndexPath  и используется для обновления конкретной ячейки в таблице
    /// - Метод с входящими данными редактирует выбранную аптечку.
    /// - Метод без входящих данных, создаёт новую аптечку.
    func showAlert(for entity: DBFirstAidKit?, by indexPath: IndexPath?)
    /// Метод для создания новой аптечки.
    /// - Parameter firstAidKit: принимает имя аптечки.
    func createData(_ firstAidKitName: String)
    /// Метод для редактирования аптечки
    /// - Parameters:
    ///   - firstAidKit: принимает аптечку, которую необходимо отредактировать
    ///   - newName: принимает новое имя для аптечки
    func updateData(_ firstAidKit: DBFirstAidKit, newName: String)
    /// Метод для удаления данных из БД
    /// - Parameter firstAidKit: принимает аптечку, которую необходимо удалить из БД
    func delete(_ firstAidKit: DBFirstAidKit)
    /// Метод для обновления бейджей на иконке приложения
    /// - Используется для обновления бейджей при входе в приложение
    func updateNotificationBadge()
    /// Метод для обновления всех уведомлений
    /// - Используется для обновления всех уведомлений после того, как были сохранены настройки.
    /// - important: Метод так же закрывает сплешскрин, после того как все уведомления для лекарств были обновлены.
    func updateAllNotifications()
    /// Метод для перехода к лекартсвам в выбранной аптечке.
    /// - Parameter currentFirstAidKit: принимает текущую аптечку
    func routeToMedicines(with currentFirstAidKit: DBFirstAidKit)
}

final class FirstAidKitsPresenter {
    
    // MARK: - Public properties
    
    weak var view: FirstAidKitsDisplayLogic?
    var interactor: FirstAidKitsBusinessLogic?
    var router: FirstAidKitRoutingLogic?
}

// MARK: - View Controller Output

extension FirstAidKitsPresenter: FirstAidKitsViewControllerOutput {
    
    func searchExpiredMedicines() {
        interactor?.searchExpiredMedicines()
    }
    
    func updatePlaceholder() {
        interactor?.updatePlaceholder()
    }
    
    // MARK: - Alerts
    
    func showAlert(for entity: DBFirstAidKit?, by indexPath: IndexPath?) {
        view?.showAlert(for: entity, by: indexPath)
    }
    
    // MARK: - CRUD methods
    
    func createData(_ firstAidKitName: String) {
        interactor?.createData(firstAidKitName)
    }
    
    func updateData(_ firstAidKit: DBFirstAidKit, newName: String) {
        interactor?.updateData(firstAidKit, newName: newName)
    }
    
    func delete(_ firstAidKit: DBFirstAidKit) {
        interactor?.delete(firstAidKit: firstAidKit)
    }
    
    // MARK: - Notifications
    
    func updateNotificationBadge() {
        interactor?.updateNotificationBadge()
    }
    
    func updateAllNotifications() {
        interactor?.updateAllNotifications()
    }
    
    // MARK: - Routing
    
    func routeToMedicines(with currentFirstAidKit: DBFirstAidKit) {
        router?.routeTo(target: .medicines(currentFirstAidKit))
    }
}

// MARK: - Presentation Logic

extension FirstAidKitsPresenter: FirstAidKitsPresentationLogic {
    
    func dismissSplashScreen() {
        view?.dismissSplashScreen()
    }
    
    func hidePlaceholder() {
        view?.hidePlaceholder()
    }
    
    func showPlaceholder() {
        view?.showPlaceholder()
    }
    
    func updateExpiredMedicinesLabel() {
        view?.updateExpiredMedicinesLabel()
    }
}
