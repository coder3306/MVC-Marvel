//
//  MVC_MarvelTests.swift
//  MVC+MarvelTests
//
//  Created by coder3306 on 2023/01/12.
//

import XCTest
@testable import MVC_Marvel

final class MVC_MarvelTests: XCTestCase, MarvelCharactersTaskOutput {
    var model = MarvelCharactersTask()
    var characters: Characters?

    override func setUpWithError() throws {
        try super.setUpWithError()
        model.output = self
    }

    override func tearDownWithError() throws {
    }
    
    func testPerformanceExample() throws {
        measure {
            
        }
    }
    
    func test_request_thirtyFive_number_response_thirtyFive_characters() {
        // given
        let listCount = 35
        let expectation = XCTestExpectation(description: "NetworkManagerTaskExpectation")
        
        // when
        self.model.requestCharactersList(for: listCount) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
        // then
        XCTAssertEqual(self.characters?.data.results.count, listCount)
    }

    func responseCharactersList(with characters: MVC_Marvel.Characters?) {
        self.characters = characters
    }
}
