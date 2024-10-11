//
//  MEDAlertView.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.10.2024.
//

import SwiftUI

struct MEDAlertView: View {
	@Binding var isShow: Bool
	@Binding var config: STAlertConfig
	var closeAction: (() -> Void)?

	private let dispatch = DispatchQueue(
		label: "alertShowed.stolichki",
		qos: .userInteractive,
		target: .main
	)

	@State private var workItem: DispatchWorkItem?

    var body: some View {
		HStack(spacing: 0) {
			Spacer()

			Text(config.text)
				.foregroundStyle(.white)
				.padding(.horizontal, 16)

			Spacer()

			Button {
				workItem?.cancel()
				isShow = false
				closeAction?()
			} label: {
				Image(systemName: "xmark.circle")
					.resizable()
					.frame(width: 20, height: 20)
					.padding(.trailing, 16)
					.foregroundStyle(.white)
			}

		}
		.frame(maxWidth: .infinity)
		.padding(.vertical, 16)
		.background(config.style.color)
		.clipShape(RoundedRectangle(cornerRadius: 16))
		.padding(.horizontal, 16)
		.opacity(isShow ? 1 : 0)
		.padding(.top, isShow ? 0 : -200)
		.animation(.spring, value: isShow)
		.onChange(of: isShow) { value in
			guard value else { return }

			workItem?.cancel()
			let newWorkItem = DispatchWorkItem {
				guard let workItem else { return }
				isShow = false
				DispatchQueue.main.asyncAfter(
					deadline: .now() + 0.5
				) {
					guard !workItem.isCancelled else { return }
					closeAction?()
				}
			}
			dispatch.asyncAfter(
				deadline: .now() + config.dismissAfter,
				execute: newWorkItem
			)
			workItem = newWorkItem
		}
    }
}

struct STAlertConfig {
	let text: LocalizedStringKey
	let style: STAlertStyle
	let dismissAfter: Double
}

enum STAlertStyle {
	case success
	case error
	case info

	var color: Color {
		switch self {
		case .success: .lightGreen
		case .error: .pinkRed
		case .info: .ripeWheat
		}
	}
}

#Preview {
	MEDAlertView(
		isShow: .constant(true),
		config: .constant(
			.init(
				text: "Уведомление",
				style: .success,
				dismissAfter: 2
			)
		),
		closeAction: {}
	)
}
