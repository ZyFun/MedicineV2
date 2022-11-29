//
//  CoreDataServiceTests.swift
//  MedicinesV2Tests
//
//  Created by Дмитрий Данилин on 30.11.2022.
//

import XCTest
@testable import MedicinesV2

final class CoreDataServiceTests: XCTestCase {

    private let coreDataService = ServiceAssembly().coreDataService
    
    override func setUp() {
        super.setUp()
        
        clearAllData()
    }
    
    override func tearDown() {
        super.tearDown()
        
        clearAllData()
    }
    
    func test_createFirstAidKit() {
        // Given
        let testKitName = "TestKit"
        
        // When
        coreDataService.performSave { context in
            self.coreDataService.create(testKitName, context: context)
        }
        
        // Then
        let exp = expectation(description: "Ожидание чтения данных из базы")
        var sut: [DBFirstAidKit] = []
        coreDataService.performSave { context in
            self.coreDataService.fetch(
                DBFirstAidKit.self,
                from: context,
                completion: { result in
                    switch result {
                    case .success(let firstAidKits):
                        sut = firstAidKits
                        exp.fulfill()
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                })
        }
        wait(for: [exp], timeout: 3)
        
        XCTAssertEqual(sut.first?.title, "TestKit")
    }
    
    func test_deleteFirstAidKit() {
        // Given
        let testKitName = "TestKit"
        coreDataService.performSave { context in
            self.coreDataService.create(testKitName, context: context)
        }
        
        // When
        coreDataService.performSave { context in
            self.coreDataService.fetch(
                DBFirstAidKit.self,
                from: context,
                completion: { result in
                    switch result {
                    case .success(let firstAidKits):
                        guard let firstAidKit = firstAidKits.first else {
                            return XCTFail("Данные не найдены")
                        }
                        
                        if firstAidKit.title == nil {
                            XCTFail("Имя не задано")
                        }
                        
                        self.coreDataService.delete(firstAidKit, context: context)
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                })
        }
        
        // Then
        var sut: [DBFirstAidKit] = []
        let expRead = expectation(description: "Ожидание чтения данных из базы")
        coreDataService.performSave { context in
            self.coreDataService.fetch(
                DBFirstAidKit.self,
                from: context,
                completion: { result in
                    switch result {
                    case .success(let firstAidKits):
                        sut = firstAidKits
                        expRead.fulfill()
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                })
        }
        wait(for: [expRead], timeout: 3)
        
        XCTAssertNil(sut.first)
    }
    
    private func clearAllData() {
        coreDataService.performSave({ context in
            self.coreDataService.fetch(
                DBFirstAidKit.self,
                from: context,
                completion: { result in
                    switch result {
                    case .success(let data):
                        data.forEach { firstAidKit in
                            self.coreDataService.delete(firstAidKit, context: context)
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
        })
    }

}
