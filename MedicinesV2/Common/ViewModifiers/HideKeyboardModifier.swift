//
//  HideKeyboardModifier.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 08.10.2024.
//

import SwiftUI

struct HideKeyboardModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
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

extension View {
	/// Модификатор для скрытия клавиатуры, по тапу в любую точку вью к которой он был присвоен,
	/// либо при начале скролла.
	/// - Note: При использовании, игнорирует любые элементы без действий, которые перекрывают вью
	func hideKeyboard() -> some View {
		self.modifier(HideKeyboardModifier())
	}
}
