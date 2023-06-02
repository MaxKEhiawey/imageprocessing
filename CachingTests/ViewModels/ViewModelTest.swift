//  ViewModelTest.swift
//  CachingTests
//
//  Created by Noye Samuel on 31/03/2023.
//

import XCTest
import Combine
@testable import Caching

class ViewModelTests: XCTestCase {
    
    func testGetImages() {
            // Given
        let networkManager = NetworkManagerMock()
        let viewModel = ViewModel(dataService: networkManager)
        let expectation = XCTestExpectation(description: "images loaded")
        
            // When
        viewModel.getImages()
        
            // Then
        XCTAssertTrue(viewModel.isLoading, "isLoading should be true while loading images")
        XCTAssertTrue(viewModel.images.isEmpty, "images should be empty while loading images")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(viewModel.isLoading, "isLoading should be false after images have loaded")
            XCTAssertFalse(viewModel.images.isEmpty, "images should not be empty after images have loaded")
            XCTAssertEqual(viewModel.images.count, 3, "images count should be 3 after images have loaded")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}

class NetworkManagerMock: NetworkManager {
    override func getImages() -> AnyPublisher<[UnsplashImage], Error> {
        return Just([
            UnsplashImage(id: "1", urls: UnsplashImageUrls(raw: "raw", full: "full", regular: "regular", small: "small", thumb: "thumb")),
            UnsplashImage(id: "2", urls: UnsplashImageUrls(raw: "raw", full: "full", regular: "regular", small: "small", thumb: "thumb")),
            UnsplashImage(id: "3", urls: UnsplashImageUrls(raw: "raw", full: "full", regular: "regular", small: "small", thumb: "thumb"))])
        .setFailureType(to: Error.self)
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
