//
//  File.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import XCTest
import Combine
@testable import Caching

class NetworkManagerTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    func testGetImages() {
        
            // Given
        let networkManager = NetworkManager()
        
            // When
        let expectation = XCTestExpectation(description: "images received")
        let publisher = networkManager.getImages()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                            expectation.fulfill()
                    case .failure(let error):
                            XCTFail("Error receiving images: \(error.localizedDescription)")
                    }
                },
                receiveValue: { images in
                        // Then
                    XCTAssertNotNil(images, "Images should not be nil")
                    XCTAssertFalse(images.isEmpty, "Images should not be empty")
                }
            )
        cancellables.insert(publisher)
        wait(for: [expectation], timeout: 5)
    }
}
