//
//  ImageLoaderVMTest.swift
//  CachingTests
//
//  Created by Noye Samuel on 31/03/2023.
//

import XCTest
import Combine
@testable import Caching

class ImageLoaderVMTests: XCTestCase {
    
    var sut: ImageLoaderVM!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        let url = URL(string: "https://example.com/image.jpg")!
        let key = "test_image"
        sut = ImageLoaderVM(url: url, key: key)
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        super.tearDown()
    }
    
    func testLoadImageFromCache() {
            // Given
        let image = UIImage(systemName: "photo")!
        CacheManager.shared.add(key: "test_image", image: image)
        
            // When
        sut.loadImage()
        
            // Then
        XCTAssertNotNil(sut.image)
        XCTAssertEqual(sut.image, image)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testDownloadImage() {
            // Given
        let expectation = self.expectation(description: "Image download")
        let url = URL(string: "https://picsum.photos/200/300")!
        sut.url = url
        
            // When
        sut.downloadImages()
        
            // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotNil(self.sut.image)
            XCTAssertTrue(self.sut.image!.size.width > 0)
            XCTAssertTrue(self.sut.image!.size.height > 0)
            XCTAssertFalse(self.sut.isLoading)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 6, handler: nil)
    }
    
}
