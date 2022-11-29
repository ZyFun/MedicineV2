//
//  FirstAidKitsInteractorTests.swift
//  MedicinesV2Tests
//
//  Created by Дмитрий Данилин on 29.11.2022.
//

import XCTest
@testable import MedicinesV2

final class FirstAidKitsInteractorTests: XCTestCase {
    
    private let service = ServiceAssembly()
    private let interactor = FirstAidKitInteractor()
    
    override func setUp() {
        super.setUp()
        
        interactor.coreDataService = service.coreDataService
        
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
        let exp = expectation(description: "Ожидание чтения данных из базы")
        interactor.createData(testKitName)
        
        var sut: [DBFirstAidKit] = []
        interactor.coreDataService?.performSave({ context in
            self.interactor.coreDataService?.fetch(
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
        })
        wait(for: [exp], timeout: 3)
        
        // Then
        XCTAssertEqual(sut.first?.title, "TestKit")
    }
    
    private func clearAllData() {
        interactor.coreDataService?.performSave({ context in
            self.interactor.coreDataService?.fetch(
                DBFirstAidKit.self,
                from: context,
                completion: { result in
                    switch result {
                    case .success(let data):
                        data.forEach { firstAidKit in
                            self.interactor.coreDataService?.delete(firstAidKit, context: context)
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
        })
    }
}
