//
//  Test.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 06.10.2024.
//

import SwiftUI

struct MedicineDetailView: View {
	// MARK: - Property wrappers

	@StateObject var viewModel: MedicineDetailViewModel
	@FocusState private var isFocused
	@FocusState private var isTextEditorFocused

	// MARK: - Body

	var body: some View {
		buildTest()
	}

	// MARK: - View Builders

	private func buildTest() -> some View {
		ScrollViewReader { scrollProxy in
			ScrollView {
				VStack(spacing: 16) {
					buildDescriptionBlock()
					buildDrugIntakeBlock()
					buildUserDescriptionBlock(scrollProxy)
					buildButtonBlock()
				}
				.padding(16)
			}
		}
		.toolbar {
			ToolbarItem(placement: .navigation) {
				Button("Готово") {
					isFocused = false
				}
				.opacity(isFocused ? 1 : 0)
				.animation(.default, value: isFocused)
			}
		}
		.tint(.darkCyan)
		.medFullScreenBackground(.backgroundMain)
		.hideKeyboard()
		.medAlertModifier(
			isShow: $viewModel.isShowAlert,
			config: $viewModel.configAlert,
			closeAction: {
				switch viewModel.screenAction {
				case .saveMedicine: viewModel.routeTo(.back)
				case .deleteMedicine: viewModel.routeTo(.back)
				case .medicineTake: break
				case .saveError: break
				case .takeError: break
				case .dosageZero: break
				}
			}
		)
		.overlay(
			buildCalendarModalView()
		)
	}

	@ViewBuilder
	private func buildDescriptionBlock() -> some View {
		MEDBlockForElements {
			buildFieldLine(
				title: "Название",
				placeholder: "Введите название лекарства*",
				text: $viewModel.name,
				accessory: {}
			)

			buildFieldLine(
				title: "Тип",
				placeholder: "Введите тип (спрей, таблетки, сироп)",
				text: $viewModel.type,
				accessory: {}
			)

			buildFieldLine(
				title: "Назначение",
				placeholder: "Введите назначение (температура, кашель)",
				text: $viewModel.purpose,
				accessory: {}
			)

			buildFieldLine(
				title: "Действующее вещество",
				placeholder: "Введите действующее вещество",
				text: $viewModel.activeIngredient,
				accessory: {}
			)

			buildFieldLine(
				title: "Производитель",
				placeholder: "Введите производителя лекарства",
				text: $viewModel.manufacturer,
				accessory: {}
			)

			buildDateLine()
		}
	}

	@ViewBuilder
	private func buildDrugIntakeBlock() -> some View {
		MEDBlockForElements {
			buildFieldLine(
				title: "В наличии",
				placeholder: "Введите количество лекарств",
				text: $viewModel.amount,
				keyboardType: .decimalPad,
				accessory: {
					MEDUnitMenu(selectedUnit: $viewModel.unitType)
				}
			)

			if viewModel.dbMedicine != nil {
				buildDrugIntakeLine()
			}
		}
	}

	@ViewBuilder
	private func buildButtonBlock() -> some View {
		Spacer(minLength: 16)
		
		MEDMainButton(
			title: "Сохранить",
			style: .main,
			action: { viewModel.createMedicine() }
		)

		if viewModel.dbMedicine != nil {
			MEDMainButton(
				title: "Удалить",
				style: .destructive,
				action: { viewModel.deleteMedicine() }
			)
		}
	}

	@ViewBuilder
	private func buildFieldLine<Content: View>(
		title: LocalizedStringKey,
		placeholder: LocalizedStringKey,
		text: Binding<String>,
		keyboardType: UIKeyboardType = .default,
		@ViewBuilder accessory: () -> Content
	) -> some View {
		Text(title)
			.font(.custom("Helvetica Neue Thin", size: 20))
			.foregroundStyle(.textMain)
			.padding(.bottom, 10)

		HStack(alignment: .bottom, spacing: 0) {
			TextField(placeholder, text: text)
				.focused($isFocused)
				.foregroundStyle(.textMain)
				.keyboardType(keyboardType)
				.submitLabel(.done)
				.onChange(of: viewModel.amount) { newValue in
					viewModel.amount = viewModel.validateInput(newValue)
				}
			
				accessory()
		}

		Divider()
			.padding(.top, 2)
			.padding(.bottom, 8)
	}

	@ViewBuilder
	private func buildDateLine() -> some View {
		HStack(spacing: 0) {
			Text("Срок годности")
				.font(.custom("Helvetica Neue Thin", size: 20))
				.foregroundStyle(.textMain)

			Spacer()

			// Из за бага 17 iOS приходится использовать кастомный календарь
			if ProcessInfo.processInfo.operatingSystemVersion.majorVersion == 17 {
				MEDMainButton(
					title: "\(viewModel.expiryDate.toMediumString())",
					style: .main,
					isFullSize: false,
					isFill: false,
					action: {
						viewModel.isShowCalendar.toggle()
					}
				)
			} else {
				DatePicker(
					"",
					selection: $viewModel.expiryDate,
					displayedComponents: .date
				)
				.labelsHidden()
			}
		}
	}

	/// Метод для отображения кастомного модального окна с календарём
	/// - Используется только для 17 iOS из-за бага. Из-за него не нажимается календарь
	@ViewBuilder
	private func buildCalendarModalView() -> some View {
		ZStack {
			if ProcessInfo.processInfo.operatingSystemVersion.majorVersion == 17 {
				if viewModel.isShowCalendar {
					Color.black.opacity(0.4)
						.edgesIgnoringSafeArea(.all)
						.onTapGesture {
							withAnimation {
								viewModel.isShowCalendar = false
							}
						}

					MEDCalendarModal(
						selectedDate: $viewModel.expiryDate,
						showCalendar: $viewModel.isShowCalendar
					)
				}
			}
		}
	}

	@ViewBuilder
	private func buildDrugIntakeLine() -> some View {
		HStack(alignment: .bottom, spacing: 0) {
			VStack(alignment: .leading, spacing: 0) {
				Text("Доза приёма")
					.font(.custom("Helvetica Neue Thin", size: 20))
					.foregroundStyle(.textMain)
					.padding(.bottom, 10)
				TextField("Введите дозу приёма", text: $viewModel.dosage)
					.focused($isFocused)
					.foregroundStyle(.textMain)
					.keyboardType(.decimalPad)
					.submitLabel(.done)
					.onChange(of: viewModel.dosage) { newValue in
						viewModel.dosage = viewModel.validateInput(newValue)
					}
			}

			MEDMainButton(
				title: "Принять",
				style: .secondary,
				isFullSize: false,
				isFill: false,
				action: { viewModel.takeMedicine() }
			)
		}

		Divider()
			.padding(.top, 2)
			.padding(.bottom, 8)
	}

	private func buildUserDescriptionBlock(_ scrollProxy: ScrollViewProxy) -> some View {
		MEDBlockForElements {
			Text("Описание")
				.font(.custom("Helvetica Neue Thin", size: 20))
				.foregroundStyle(.textMain)
				.padding(.bottom, 10)
			TextEditor(text: $viewModel.userDescription)
//				.scrollDisabled(true) // TODO: (MEDIC-84) Выключить скролл после поднятия таргета до 16.
				.foregroundStyle(.textMain)
				.background(.backgroundMainElement)
				.frame(minHeight: 100)
				.id("descriptionField")
				.focused($isTextEditorFocused)
				.onChange(of: viewModel.userDescription) { _ in
					withAnimation {
						scrollProxy.scrollTo("descriptionField", anchor: .bottom)
					}
				}
				.overlay(alignment: .topLeading) {
					if !isTextEditorFocused && viewModel.userDescription.isEmpty {
						Text("Введите описание или комментарии")
							.foregroundStyle(.gray)
							.padding(.top, 7)
							.padding(.leading, 1)
					}
				}
		}
	}

// TODO: (MEDIC-85) раскомментировать и начать с этим работать после поднятия таргета до 16 версии
//	@ToolbarContentBuilder
//	private func keyboardToolbar(_ needToolBar: Bool) -> some ToolbarContent {
//		if needToolBar {
//			ToolbarItemGroup(placement: .keyboard) {
//				Spacer()
//				Button("Готово") {
//					isFocused = false
//				}
//			}
//		}
//	}
}
