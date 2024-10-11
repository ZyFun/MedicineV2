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

	// MARK: - Body

	var body: some View {
		buildTest()
	}

	// MARK: - Build methods

	private func buildTest() -> some View {
		ScrollView {
			VStack(spacing: 16) {
				buildDescriptionBlock()
				buildDrugIntakeBlock()
				buildButtonBlock()
			}
			.padding(16)
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
	}

	// MARK: - View Builders

	@ViewBuilder
	func buildDescriptionBlock() -> some View {
		MEDBlockForElements {
			buildFieldLine(
				title: "Название",
				placeholder: "Введите название лекарства*",
				text: $viewModel.name
			)

			buildFieldLine(
				title: "Тип",
				placeholder: "Введите тип (спрей, таблетки, сироп)",
				text: $viewModel.type
			)

			buildFieldLine(
				title: "Назначение",
				placeholder: "Введите назначение (температура, кашель)",
				text: $viewModel.purpose
			)

			buildDateLine()
		}
	}

	@ViewBuilder
	func buildDrugIntakeBlock() -> some View {
		MEDBlockForElements {
			buildFieldLine(
				title: "В наличии",
				placeholder: "Введите количество лекарств",
				text: $viewModel.amount,
				keyboardTupe: .decimalPad
			)

			if viewModel.dbMedicine != nil {
				buildDrugIntakeLine()
			}
		}
	}

	@ViewBuilder
	func buildButtonBlock() -> some View {
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
	func buildFieldLine(
		title: LocalizedStringKey,
		placeholder: LocalizedStringKey,
		text: Binding<String>,
		keyboardTupe: UIKeyboardType = .default
	) -> some View {
		Text(title)
			.font(.custom("Helvetica Neue Thin", size: 20))
			.foregroundStyle(.textMain)
			.padding(.bottom, 10)
		TextField(placeholder, text: text)
			.focused($isFocused)
			.foregroundStyle(.textMain)
			.keyboardType(keyboardTupe)
			.submitLabel(.done)
			.onChange(of: viewModel.amount) { newValue in
				viewModel.amount = viewModel.validateInput(newValue)
			}
		Divider()
			.padding(.top, 2)
			.padding(.bottom, 8)
	}

	@ViewBuilder
	func buildDateLine() -> some View {
		HStack(spacing: 0) {
			Text("Срок годности")
				.font(.custom("Helvetica Neue Thin", size: 20))
				.foregroundStyle(.textMain)

			Spacer()

			DatePicker(
				"",
				selection: $viewModel.expiryDate,
				displayedComponents: .date
			)
			.labelsHidden()
		}
	}

	@ViewBuilder
	func buildDrugIntakeLine() -> some View {
		HStack(spacing: 0) {
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

			// TODO: Показать всплывающее уведомление, которое сообщит что лекарство принято
			MEDMainButton(
				title: "Принять",
				style: .secondary,
				isFill: false,
				action: { viewModel.takeMedicine() }
			)
		}

		Divider()
			.padding(.top, 2)
			.padding(.bottom, 8)
	}

// TODO: () раскомментировать и начать с этим работать после поднятия таргета до 16 версии
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

// TODO: После блока приёма разместить описание лекарства. Большой блок с пользовательскими комментариями
