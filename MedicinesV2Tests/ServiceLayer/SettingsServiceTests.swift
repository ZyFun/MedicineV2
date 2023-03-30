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
    
    func test_save_withSortAscendingTrue_shouldSaved() {
        // Given
        let ascending = true
        
        // When
        sortSettingService.saveSetting(ascending: ascending, with: .sortAscending)
        waiting(time: 1, description: "Ожидание сохранения данных")
        
        // Then
        let sut = makeSutAscending()
        XCTAssertTrue(sut)
    }
    
    func test_get_withSortAscendingDefault_shouldAscendingFalse() {
        // Given
        var ascending = true
        
        // When
        ascending = sortSettingService.getAscending(with: .sortAscending)
        
        // Then
        XCTAssertFalse(ascending)
    }
    
    func test_delete_shouldAscendingFalse() {
        // Given
        let ascending = true
        sortSettingService.saveSetting(ascending: ascending, with: .sortAscending)
        waiting(time: 1, description: "Ожидание сохранения данных")
        
        // When
        sortSettingService.delete(with: .sortAscending)
        waiting(time: 1, description: "Ожидание удаления данных")
        
        // Then
        let sut = makeSutAscending()
        XCTAssertFalse(sut)
    }
    
    private func makeSutAscending() -> Bool {
        sortSettingService.getAscending(with: .sortAscending)
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
