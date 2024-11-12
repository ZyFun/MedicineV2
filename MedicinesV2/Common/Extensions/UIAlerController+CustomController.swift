//
//  UIAlerController+CustomController.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 10.11.2021.
//

import UIKit

extension UIAlertController {
    
    /// Кейсы с сообщениями об ошибке
    enum ErrorMessage: String {
		case unownedError
    }
    
    /// Метод для создания кастомного алерт контроллера. Используется для работы с  добавлением и редактированием названия аптечки
    /// - Parameter title: принимает заголовок для алерта
    /// - Returns: возвращает кастомный алерт контроллер
    static func createAlertController(with title: String) -> UIAlertController {
        UIAlertController(title: title,
                          message: String(localized: "Введите название или расположение аптечки"),
                          preferredStyle: .alert)
    }
    
    /// Алерт для отображения сообщения об ошибке.
    /// - Parameter errorMessage: принимает кейс с ошибкой,
    /// для отображения нужного сообщения
    static func createErrorAlertController(
        errorMessage: UIAlertController.ErrorMessage
    ) -> UIAlertController {
        
        UIAlertController(
            title: String(localized: "Ошибка"),
			message: errorMessage.rawValue,
            preferredStyle: .alert
        )
    }
    
    /// Действия для алерта с выводом сообщения об ошибке.
    func actionError() {
        let actionOk = UIAlertAction(title: String(localized: "Ok"), style: .cancel, handler: nil)

        addAction(actionOk)
    }
    
    /// Метод действий для алерт контроллера
    /// - Parameters:
    ///   - firstAidKit: принимает аптечку для редактирования названия или сохранения новой
    ///   - completion: возвращает новое значение названия для аптечки
    func action(firstAidKit: DBFirstAidKit?, completion: @escaping (String) -> Void) {
		let buttonTitle = firstAidKit == nil
		? String(localized: "Сохранить")
		: String(localized: "Обновить")

        let saveAction = UIAlertAction(title: buttonTitle, style: .default) { [unowned self] _ in
            guard let newValue = textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: String(localized: "Отмена"), style: .cancel)

        addAction(cancelAction)
        addAction(saveAction)
        addTextField { textField in
            textField.autocapitalizationType = .sentences
            
            if firstAidKit != nil {
                textField.text = firstAidKit?.title
                textField.placeholder = String(localized: "Введите новое название аптечки")
            } else {
                textField.placeholder = String(localized: "Введите название новой аптечки")
            }
        }
    }
}
