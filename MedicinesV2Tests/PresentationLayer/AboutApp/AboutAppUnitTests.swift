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
        XCTAssertNotNil(view)
        XCTAssertNotNil(model)
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(presenter?.view)
    }
    
    // MARK: - Presenter tests
    
    func test_displayAppVersion_setAppInfo_displayedVersion() {
        // Given
        let version = model.version
        
        // When
        presenter.presentAppInfo()
        
        // Then
        XCTAssertEqual(view.infoModel?.version, version)
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
        XCTAssertEqual(model.version, data.version)
        XCTAssertEqual(model.developer, data.developer)
        XCTAssertEqual(model.discordUrl, data.discordUrl)
        XCTAssertEqual(model.vkUrl, data.vkUrl)
        XCTAssertEqual(model.tgUrl, data.tgUrl)
        XCTAssertEqual(model.frameworks, data.frameworks)
    }
    
}
