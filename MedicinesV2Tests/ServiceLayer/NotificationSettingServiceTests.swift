//
//  NotificationSettingServiceTests.swift
//  MedicinesV2Tests
//
//  Created by Дмитрий Данилин on 15.05.2023.
//

import XCTest
@testable import MedicinesV2

final class NotificationSettingServiceTests: XCTestCase {
    private let notificationSettingService: NotificationSettings = SettingsService.shared
    
    override func setUp() {
        super.setUp()
        
        notificationSettingService.deleteNotificationSettings()
        waiting(time: 2, description: "Ожидание обнуления настроек")
    }
    
    override func tearDown() {
        super.tearDown()
        
        notificationSettingService.deleteNotificationSettings()
        waiting(time: 2, description: "Ожидание обнуления настроек")
    }
    
    // MARK: - Notification settings tests
    
    func test_deleteNotificationSettings_shouldDataDeleted() {
        // Given
        let sut = NotificationSettingModel(
            hourNotifiable: 22,
            isRepeat: true
        )
        var savedSut: NotificationSettingModel? = sut
        
        do {
            try notificationSettingService.saveNotificationSettings(
                hourNotifiable: sut.hourNotifiable,
                isRepeat: sut.isRepeat
            )
        } catch {
            debugPrint(error.localizedDescription)
        }
        waiting(time: 1, description: "Ожидание сохранения данных")
        
        // When
        notificationSettingService.deleteNotificationSettings()
        waiting(time: 1, description: "Ожидание удаления данных")
        
        // Then
        do {
            savedSut = try notificationSettingService.getNotificationSettings()
            waiting(time: 2, description: "Ожидание получения данных")
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertNil(savedSut)
    }
    
    func test_saveNotificationSetting_shouldSaved() {
        // Given
        let sut = NotificationSettingModel(
            hourNotifiable: 22,
            isRepeat: true
        )
        var savedSut: NotificationSettingModel?
        
        // When
        do {
            try notificationSettingService.saveNotificationSettings(
                hourNotifiable: sut.hourNotifiable,
                isRepeat: sut.isRepeat
            )
        } catch {
            XCTFail(error.localizedDescription)
        }
        waiting(time: 1, description: "Ожидание сохранения данных")
        
        // Then
        do {
            savedSut = try notificationSettingService.getNotificationSettings()
            waiting(time: 2, description: "Ожидание получения данных")
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertNotNil(savedSut)
        XCTAssertEqual(sut.isRepeat, savedSut?.isRepeat)
        XCTAssertEqual(sut.hourNotifiable, savedSut?.hourNotifiable)
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
