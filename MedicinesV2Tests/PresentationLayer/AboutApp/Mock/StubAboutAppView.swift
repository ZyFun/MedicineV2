//
//  StubAboutAppView.swift
//  MedicinesV2Tests
//
//  Created by Дмитрий Данилин on 16.01.2023.
//

import Foundation
@testable import MedicinesV2

final class StubAboutAppView: AboutAppOutput {
    var version: String?

    func setVersion(_ version: String) {
        self.version = version
    }

    func dismiss() {}
}
