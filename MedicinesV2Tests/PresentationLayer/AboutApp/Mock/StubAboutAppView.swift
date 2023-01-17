//
//  StubAboutAppView.swift
//  MedicinesV2Tests
//
//  Created by Дмитрий Данилин on 16.01.2023.
//

import Foundation
@testable import MedicinesV2

final class StubAboutAppView: AboutAppView {
    var infoModel: AboutAppInfoModel?
    
    func setAppInfo(from infoModel: AboutAppInfoModel) {
        self.infoModel = infoModel
    }

    func dismiss() {}
}
