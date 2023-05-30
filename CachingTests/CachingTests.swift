//
//  CachingTests.swift
//  CachingTests
//
//  Created by Noye Samuel on 28/03/2023.
//

import XCTest
@testable import Caching

class CacheManagerTest: XCTestCase {
    
    var sut: CacheManager!
    
    override func setUp() {
        super.setUp()
        sut = CacheManager.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testAddImageToCache() {
            // Given
        let key = "test_image"
        let image = UIImage(systemName: "photo")!
        
            // When
        sut.add(key: key, image: image)
        
            // Then
        XCTAssertNotNil(sut.imageCache.object(forKey: key as NSString))
        XCTAssertEqual(sut.imageCache.object(forKey: key as NSString), image)
    }
    
    func testGetImageFromCache() {
            // Given
        let key = "test_image"
        let image = UIImage(systemName: "photo")!
        sut.imageCache.setObject(image, forKey: key as NSString)
        
            // When
        let result = sut.get(key: key)
        
            // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result, image)
    }
    
    func testGetMissingImageFromCache() {
            // Given
        let key = "missing_image"
        
            // When
        let result = sut.get(key: key)
        
            // Then
        XCTAssertNil(result)
    }
    
}
