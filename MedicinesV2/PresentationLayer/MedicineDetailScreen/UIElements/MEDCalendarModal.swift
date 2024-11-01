//
//  CalendarModal.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 01.11.2024.
//

import SwiftUI

struct MEDCalendarModal: View {
	@Binding var selectedDate: Date
	@Binding var showCalendar: Bool

	var body: some View {
		VStack {
			DatePicker(
				"",
				selection: $selectedDate,
				displayedComponents: .date
			)
			.padding(16)

			MEDMainButton(
				title: "Применить",
				style: .main,
				isFullSize: false,
				isFill: false,
				action: {
					showCalendar = false
				}
			)
			.padding(.bottom, 16)
		}
		.frame(width: 300, height: 300)
		.background(.backgroundMainElement)
		.clipShape(RoundedRectangle(cornerRadius: 16))
		.shadow(radius: 10)
		.tint(.darkCyan)
	}
}
