//
//  MEDMainButton.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 08.10.2024.
//

import SwiftUI

/// Основная кнопка приложения
/// - Parameters:
/// - isFill: При установки значения в true, растягивает кнопку на всю доступную ширину
struct MEDMainButton: View {
	let title: LocalizedStringKey
	let style: MEDMainButtonStyle
	var isFullSize = true
	var isFill: Bool = true
	let action: () -> Void

	var body: some View {
		Button {
			action()
		} label: {
			HStack {
				Text(title)
					.frame(maxWidth: isFill ? .infinity : nil)
			}
			.padding(.vertical, isFullSize ? 16 : 6)
			.padding(.horizontal, 16)
			.foregroundStyle(style.textColor)
			.background(style.buttonColor)
			.clipShape(RoundedRectangle(cornerRadius: isFullSize ? 16 : 8))
			.shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
		}
	}
}

struct MEDMainButtonStyle {
	let buttonColor: Color
	let textColor: Color = .white

	static let main = MEDMainButtonStyle(buttonColor: .darkCyan)
	static let secondary = MEDMainButtonStyle(buttonColor: .ripeWheat)
	static let destructive = MEDMainButtonStyle(buttonColor: .pinkRed)
}
