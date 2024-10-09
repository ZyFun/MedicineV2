//
//  MEDDescriptionBlock.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 08.10.2024.
//

import SwiftUI

/// UI элемент, который оборачивает всё содержимое в VStack и добавляет вокруг себя отступы,
/// закругляет края и добавляет тень.
/// - Используется для выделения элементов в логические блоки
/// - Выравнивает элементы по левому краю
struct MEDBlockForElements<Content: View>: View {
	@ViewBuilder let content: () -> Content

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			content()
		}
		.padding(16)
		.background(.backgroundMainElement)
		.clipShape(RoundedRectangle(cornerRadius: 16))
		.shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
	}
}
