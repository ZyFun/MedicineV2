//
//  File.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 08.10.2024.
//

import SwiftUI

extension View {
	/// Модификатор для скрытия клавиатуры, по тапу в любую точку вью к которой он был присвоен
	/// - Note: При использовании, игнорирует любые элементы без действий, которые перекрывают вью
	func hideKeyboard() -> some View {
		self
			.onTapGesture {
				UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
			}
			.simultaneousGesture(
				DragGesture().onChanged { _ in
					UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
				}
			)
	}
}
