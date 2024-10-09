//
//  MEDFullScreenBackgroundModifier.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 06.10.2024.
//

import SwiftUI

struct MEDFullScreenBackgroundModifier: ViewModifier {
	let color: Color

	func body(content: Content) -> some View {
		ZStack {
			color
				.edgesIgnoringSafeArea(.all)
			content
		}
	}
}

extension View {
	/// Модификатор для установки фона на основное вью
	/// - Parameter color: принимает цвет, который будет установлен на фон
	func medFullScreenBackground(_ color: Color) -> some View {
		self.modifier(MEDFullScreenBackgroundModifier(color: color))
	}
}
