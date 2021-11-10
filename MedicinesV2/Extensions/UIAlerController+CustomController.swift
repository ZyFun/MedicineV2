//
//  UIAlerController+CustomController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 10.11.2021.
//

import UIKit

extension UIAlertController {
    
    /// Метод для создания кастомного алерт контроллера. Используется для работы с  добавлением и редактированием названия аптечки
    /// - Parameter title: принимает заголовок для алерта
    /// - Returns: возвращает кастомный алерт контроллер
    static func createAlertController(with title: String) -> UIAlertController {
        UIAlertController(title: title,
                          message: "Введите название или расположение новой аптечки",
                          preferredStyle: .alert)
    }
    
    /// Метод действий для алерт контроллера
    /// - Parameters:
    ///   - firstAidKit: принимает аптечку для редактирования названия или сохранения новой
    ///   - completion: возвращает новое значение названия для аптечки
    func action(firstAidKit: FirstAidKit?, completion: @escaping (String) -> Void) {
        let buttonTitle = firstAidKit == nil ? "Сохранить" : "Обновить"
        
        let saveAction = UIAlertAction(title: buttonTitle, style: .default) { [unowned self] _ in
            guard let newValue = textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textFields in
            if firstAidKit != nil {
                textFields.text = firstAidKit?.title
                textFields.placeholder = "Введите новое название аптечки"
            } else {
                textFields.placeholder = "Введите название новой аптечки"
            }
        }
    }
}
