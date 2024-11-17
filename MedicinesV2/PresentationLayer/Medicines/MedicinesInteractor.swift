//
//  MedicinesInteractor.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.11.2021.
//

import Foundation
import DTLogger

/// Протокол для работы с бизнес логикой модуля
protocol MedicinesBusinessLogic {
    /// Метод для обновления значка уведомлений на иконке приложения
    /// - Обновление происходит в глобальном потоке через 1 секунды после срабатывания метода.
    ///   Это необходимо для того, чтобы данные в базе успели обновится и я получил новые данные.
    func updateNotificationBadge()
    /// Метод для удаления данных из БД
    /// Запрос на обновление данных должен происходить
    /// в момент возврата на экран со списком лекарств.
    /// - Parameter medicine: принимает лекарство, которое необходимо удалить из БД
    func delete(medicine: DBMedicine)
    /// Метод для обновления состояния плейсхолдера
    /// - Используется для скрытия или отображения плейсхолдера
    /// - Если в базе аптечки есть лекарства, скрывается, иначе - отображается
    /// - Parameter currentFirstAidKit: принимает текущую аптечку, в которой будет работа
    ///                                 с плейсхолдером.
    func updatePlaceholder(for currentFirstAidKit: DBFirstAidKit?)
}

final class MedicinesInteractor {
    
    // MARK: - Public properties
    
    /// Ссылка на презентер
    weak var presenter: MedicinesPresentationLogiс?
    
    // MARK: - Dependencies
    
    var coreDataService: ICoreDataService?
    var notificationManager: INotificationMedicineManager?
    var logger: DTLogger?
    
    /// Свойство текущей аптечки
    /// - необходимо для фильтрации лекарств в текущей аптечке и обновления плейсхолдера
    ///   после удаления всех лекарств в этой аптечке.
    var currentFirstAidKit: DBFirstAidKit?
}

// MARK: - BusinessLogic

extension MedicinesInteractor: MedicinesBusinessLogic {
    func delete(medicine: DBMedicine) {
        coreDataService?.performSave { [weak self] context in
            guard let self = self else { return }
            
            var firstAidKit: DBFirstAidKit?
            
            self.notificationManager?.deleteNotification(for: medicine)
            self.coreDataService?.delete(medicine, context: context)
            self.updateNotificationBadge()
            
            self.coreDataService?.fetch(DBFirstAidKit.self, from: context) { result in
                switch result {
                case .success(let dbFirstAidKits):
                    firstAidKit = self.fetchFirstAidKit(
                        from: dbFirstAidKits,
                        for: self.currentFirstAidKit
                    )
                    
                    self.updatePlaceholder(for: firstAidKit)
                case .failure(let error):
                    self.logger?.log(.error, error.localizedDescription)
                }
            }
        }
    }
    
    func updateNotificationBadge() {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
            let data = self.coreDataService?.fetchRequest(
                String(describing: DBMedicine.self)
            ) as? [DBMedicine]
            self.notificationManager?.setupBadgeForAppIcon(data: data)
        }
    }
    
    /// Метод для получения текущей аптечки из другого контекста
    /// - Parameters:
    ///   - firstAidKits: Принимает аптечки в текущий контекст для фильтрации
    ///   - currentFirstAidKit: Принимает текущую аптечку из другого контекста  для поиска
    ///     нужной в текущем контексте по ID
    /// - Returns: Возвращает найденную аптечку
    /// - Метод необходим для правильной работы с данными в разных контекстах
    private func fetchFirstAidKit(
        from firstAidKits: [DBFirstAidKit],
        for currentFirstAidKit: DBFirstAidKit?
    ) -> DBFirstAidKit? {
        
        guard let currentFirstAidKitID = currentFirstAidKit?.objectID else {
            logger?.log(.error, "Не удалось найти ID объекта")
            return nil
        }
        
        if let firstAidKit = firstAidKits.filter({ $0.objectID == currentFirstAidKitID }).first {
            return firstAidKit
        } else {
            logger?.log(.warning, "Объект не найден")
            return nil
        }
    }
    
    func updatePlaceholder(for currentFirstAidKit: DBFirstAidKit?) {
        guard let currentFirstAidKit = currentFirstAidKit else {
            logger?.log(.error, "Аптечка не была передана")
            return
        }
        
        if currentFirstAidKit.medicines == [] {
            presenter?.showPlaceholder()
            logger?.log(.info, "Лекарств в аптечке нет. Плейсхолдер отображен")
        }
    }
}
