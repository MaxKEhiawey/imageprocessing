//
//  CacheManagerTest.swift
//  CachingTests
//
//  Created by Noye Samuel on 31/03/2023.
//

import XCTest
@testable import Caching 

class CacheManagerTests: XCTestCase {
    
    func testAddAndGet() {
            // Given
        let cacheManager = CacheManager.shared
        let image = UIImage(systemName: "house")!
        let key = "image_key"
        
            // When
        cacheManager.add(key: key, image: image)
        
            // Then
        let cachedImage = cacheManager.get(key: key)
        XCTAssertNotNil(cachedImage, "cached image should not be nil")
        XCTAssertEqual(cachedImage, image, "cached image should be equal to the original image")
    }
}
