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
    private var model: AboutAppModel!
    private var presenter: AboutAppPresenter!
    
    override func setUp() {
        super.setUp()
        
        view = StubAboutAppView()
        model = AboutAppModel(
            description: "Аптечка и т.д.",
            nameDeveloper: "Я",
            version: "100500"
        )
        
        presenter = AboutAppPresenter(view: view, info: model)
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
    
    func test_displayAppVersion_setVersion_displayedVersion() {
        // Given
        let version = model.version
        
        // When
        presenter.presentAppVersion()
        
        // Then
        XCTAssertEqual(view.version, version, "Версия не установилась")
    }
    
    // MARK: - Model tests
    
    func test_aboutAppModelBuilding_buildModel_modelBuilded() {
        // Given
        let description = "Аптечка и т.д."
        let nameDeveloper = "Я"
        let version = "100500"
        
        // Then
        XCTAssertEqual(model.description, description, "Описание не совпадает")
        XCTAssertEqual(model.nameDeveloper, nameDeveloper, "Имя разработчика не совпадает")
        XCTAssertEqual(model.version, version, "Номер версии не совпадает")
    }
    
}
