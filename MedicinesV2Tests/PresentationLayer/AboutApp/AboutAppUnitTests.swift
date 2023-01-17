//
//  AboutAppUnitTests.swift
//  MedicinesV2Tests
//
//  Created by Дмитрий Данилин on 16.01.2023.
//

import XCTest
@testable import MedicinesV2

final class AboutAppUnitTests: XCTestCase {
    
    private var view: StubAboutAppView!
    private var model: AboutAppInfoModel!
    private var presenter: AboutAppPresenter!
    
    override func setUp() {
        super.setUp()
        
        view = StubAboutAppView()
        model = AboutAppInfoModel(
            version: "100500",
            developer: "Я",
            discordUrl: "DC",
            vkUrl: "VK",
            tgUrl: "TG",
            frameworks: "Swiftlint"
        )
        
        presenter = AboutAppPresenter(view: view, infoModel: model)
    }
    
    override func tearDown() {
        super.tearDown()
        
        view = nil
        model = nil
        presenter = nil
    }
    
    // MARK: - Module tests
    
    func test_createModule_aboutApp_moduleIsNotNil() {
        // Then
        XCTAssertNotNil(view, "Вью не должно быть пустым")
        XCTAssertNotNil(model, "Модель не должна быть пустой")
        XCTAssertNotNil(presenter, "Презентер не должен быть пустым")
        XCTAssertNotNil(presenter?.view, "Мдуль не собрался")
    }
    
    // MARK: - Presenter tests
    
    func test_displayAppVersion_setAppInfo_displayedVersion() {
        // Given
        let version = model.version
        
        // When
        presenter.presentAppInfo()
        
        // Then
        XCTAssertEqual(view.infoModel?.version, version, "Версия не установилась")
    }
    
    // MARK: - Model tests
    
    func test_aboutAppModelBuilding_buildModel_modelBuilded() {
        // Given
        let data = AboutAppInfoModel(
            version: "100500",
            developer: "Я",
            discordUrl: "DC",
            vkUrl: "VK",
            tgUrl: "TG",
            frameworks: "Swiftlint"
        )
        
        // Then
        XCTAssertEqual(model.version, data.version, "Номер версии не совпадает")
        XCTAssertEqual(model.developer, data.developer, "Разработчик не совпадает")
        XCTAssertEqual(model.discordUrl, data.discordUrl, "Ссылка на дискорд не совпадает")
        XCTAssertEqual(model.vkUrl, data.vkUrl, "Ссылка на ВК не совпадает")
        XCTAssertEqual(model.tgUrl, data.tgUrl, "Ссылка на ТГ не совпадает")
        XCTAssertEqual(model.frameworks, data.frameworks, "Фреймворки не совпадают")
    }
    
}
