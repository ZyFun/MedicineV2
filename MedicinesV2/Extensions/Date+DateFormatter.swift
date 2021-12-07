//
//  Date+DateFormatter.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 07.12.2021.
//

import Foundation

extension Date {
    /// Переводит  дату в текст.
    /// - Parameter format: Принимает строку для форматирования даты по маске.
    /// Значение по умолчанию имеет российский формат.
    /// - Returns: Возвращает дату в виде строки отформатированной по маске.
    func toString(format: String = "dd.MM.yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
