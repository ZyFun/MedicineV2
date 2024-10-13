//
//  MEDUnitMenu.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 13.10.2024.
//

import SwiftUI

struct MEDUnitMenu: View {
	@Binding var selectedUnit: UnitType

	var body: some View {
		VStack(spacing: 0) {
			Menu {
				ForEach(UnitType.allCases, id: \.self) { unit in
					Button {
						selectedUnit = unit
					} label: {
						Text(unit.value)
						if selectedUnit == unit {
							Image(systemName: "checkmark")
						}
					}
				}
			} label: {
				HStack(spacing: 6) {
					Text(selectedUnit.value)
						.foregroundColor(.textMain)
						.lineLimit(1)
					Image(systemName: "chevron.down")
						.foregroundColor(.gray)
				}
				.padding(.vertical, 6)
				.padding(.horizontal, 12)
				.overlay(
					RoundedRectangle(cornerRadius: 8)
						.stroke(.gray, lineWidth: 1)
				)
				.animation(.linear(duration: 0.1), value: selectedUnit)
			}
		}
	}
}

extension MEDUnitMenu {
	enum UnitType: String, CaseIterable {
		case pcs = "шт"
		case ml = "мл"
		case g = "г"
		case mg = "мг"

		var value: LocalizedStringKey {
			switch self {
			case .pcs: "шт"
			case .ml: "мл"
			case .g: "г"
			case .mg: "мг"
			}
		}
	}
}

#Preview {
	MEDUnitMenu(selectedUnit: .constant(.pcs))
}
