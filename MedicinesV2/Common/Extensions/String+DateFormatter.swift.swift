//
//  String+DateFormatter.swift.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 07.12.2021.
//

import Foundation

extension String {
    /// Переводит строку в дату.
    /// - Parameter format: Принимает строку для форматирования даты по маске.
    /// Значение по умолчанию имеет российский формат.
    /// - Returns: Возвращает дату отформатированную по маске.
    func toDate(withFormat format: String = "dd.MM.yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}
