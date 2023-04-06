//
//  SettingsServiceTests.swift
//  MedicinesV2Tests
//
//  Created by Дмитрий Данилин on 30.03.2023.
//

import XCTest
@testable import MedicinesV2

final class SettingsServiceTests: XCTestCase {
    private let sortSettingService: SortableSettings = SettingsService()
    
    override func setUp() {
        super.setUp()
        
        sortSettingService.deleteSortSettings()
        waiting(time: 2, description: "Ожидание обнуления настроек")
    }
    
    override func tearDown() {
        super.tearDown()
        
        sortSettingService.deleteSortSettings()
        waiting(time: 2, description: "Ожидание обнуления настроек")
    }
    
    // MARK: - Common methods
    
    func test_deleteSortSettings_shouldDataDeleted() {
        // Given
        var ascending: Bool
        let field = "title"
        var sutField = ""
        
        sortSettingService.saveSortSetting(ascending: .up)
        sortSettingService.saveSortSetting(field: .expiryDate)
        waiting(time: 1, description: "Ожидание сохранения данных")
        
        // When
        sortSettingService.deleteSortSettings()
        waiting(time: 1, description: "Ожидание удаления данных")
        
        // Then
        ascending = sortSettingService.getSortAscending()
        sutField = sortSettingService.getSortField()
        XCTAssertTrue(ascending)
        XCTAssertEqual(field, sutField)
    }
    
    // MARK: - Ascending settings tests
    
    func test_saveSortSetting_ascendingUp_shouldSaved() {
        // Given
        var ascending: Bool
        
        // When
        sortSettingService.saveSortSetting(ascending: .up)
        waiting(time: 1, description: "Ожидание сохранения данных")
        
        // Then
        ascending = sortSettingService.getSortAscending()
        XCTAssertTrue(ascending)
    }
    
    func test_getSortAscending_withSortAscendingDefault_shouldAscendingFalse() {
        // Given
        var ascending: Bool
        
        // When
        ascending = sortSettingService.getSortAscending()
        
        // Then
        XCTAssertTrue(ascending)
    }
    
    // MARK: - Field settings tests
    
    func test_saveSortSetting_withFieldDateCreated_shouldSaved() {
        // Given
        let field = #keyPath(DBMedicine.dateCreated)
        var sutField = ""
        
        // When
        sortSettingService.saveSortSetting(field: .dateCreated)
        waiting(time: 1, description: "Ожидание сохранения данных")
        
        // Then
        sutField = sortSettingService.getSortField()
        XCTAssertEqual(field, sutField)
    }
    
    func test_getSortField_withFieldDefault_shouldFieldTitle() {
        // Given
        let field = #keyPath(DBMedicine.title)
        var sutField = ""
        
        // When
        sutField = sortSettingService.getSortField()
        waiting(time: 1, description: "Ожидание сохранения данных")
        
        // Then
        XCTAssertEqual(field, sutField)
    }
    
    // MARK: - Private methods
    
    /// Метод для установки паузы в тестах
    /// - нужен к примеру для задержки теста при сохранении, так как к примеру UserDefaults не
    /// умеет сохранять на симуляторе мгновенно и тест падает.
    /// - Parameters:
    ///   - time: время ожидания в секундах
    ///   - description: описание чего мы ожидаем
    private func waiting(time: Int, description: String) {
        let exp = expectation(description: description)
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(time)) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: TimeInterval(time + 1))
    }
}
