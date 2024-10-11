//
//  MEDAlertModifier.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 11.10.2024.
//

import SwiftUI

struct MEDAlertModifier: ViewModifier {
	@Binding var isShow: Bool
	@Binding var config: STAlertConfig
	let closeAction: () -> Void

	func body(content: Content) -> some View {
		ZStack(alignment: .top) {
			content
			MEDAlertView(isShow: $isShow, config: $config, closeAction: closeAction)
		}
	}
}

extension View {
	func medAlertModifier(isShow: Binding<Bool>, config: Binding<STAlertConfig>, closeAction: @escaping () -> Void) -> some View {
		self.modifier(MEDAlertModifier(isShow: isShow, config: config, closeAction: closeAction))
	}
}
