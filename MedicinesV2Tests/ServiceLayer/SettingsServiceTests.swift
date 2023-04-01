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
        
        sortSettingService.delete(with: .sortAscending)
        waiting(time: 2, description: "Ожидание обнуления настроек")
    }
    
    override func tearDown() {
        super.tearDown()
        
        sortSettingService.delete(with: .sortAscending)
        waiting(time: 2, description: "Ожидание обнуления настроек")
    }
    
    // MARK: - Ascending settings tests
    
    func test_saveSetting_withSortAscendingTrue_shouldSaved() {
        // Given
        var ascending = true
        
        // When
        sortSettingService.saveSetting(ascending: ascending, with: .sortAscending)
        waiting(time: 1, description: "Ожидание сохранения данных")
        
        // Then
        ascending = sortSettingService.getAscending(with: .sortAscending)
        XCTAssertTrue(ascending)
    }
    
    func test_getAscending_withSortAscendingDefault_shouldAscendingFalse() {
        // Given
        var ascending = true
        
        // When
        ascending = sortSettingService.getAscending(with: .sortAscending)
        
        // Then
        XCTAssertFalse(ascending)
    }
    
    func test_delete_shouldAscendingFalse() {
        // Given
        var ascending = true
        sortSettingService.saveSetting(ascending: ascending, with: .sortAscending)
        waiting(time: 1, description: "Ожидание сохранения данных")
        
        // When
        sortSettingService.delete(with: .sortAscending)
        waiting(time: 1, description: "Ожидание удаления данных")
        
        // Then
        ascending = sortSettingService.getAscending(with: .sortAscending)
        XCTAssertFalse(ascending)
    }
    
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
