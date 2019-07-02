//
//  ProductStorageTests.swift
//  RetechLabsTestTests
//
//  Created by Victor on 02/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest
@testable import RetechLabsTest

class ProductStorageTests: XCTestCase {

    var productStorage: ProductStorage!
    
    override func setUp() {
        super.setUp()
        
        productStorage =  ProductStorage.shared
    }

    override func tearDown() {
        super.tearDown()
        productStorage.removeAll()
    }

    //MARK: Saving
    func test_save_productStorage() {
        let product = MDProduct.init()
        productStorage.saveToStorage(object: product)
        let products = productStorage.getObjectsFromStorage()
        let filterProducts = products.filter { (databaseProduct) -> Bool in
            return databaseProduct == product
        }
        
        let productCount = filterProducts.count
        
        XCTAssertEqual(productCount, 1)
    }
    
    //MARK: Fetching
    func test_fetch_productStorage() {
        for _ in 0 ..< 10 {
            let product = MDProduct.init()
            productStorage.saveToStorage(object: product)
        }
        let products = productStorage.getObjectsFromStorage()
        
        let productCount = products.count
        
        XCTAssertEqual(productCount, 10)
    }
    
    //MARK: Removing
    func test_remove_productStorage() {
        var products: [MDProduct] = []
        
        for _ in 0 ..< 3 {
            let product = MDProduct.init()
            products.append(product)
            productStorage.saveToStorage(object: product)
        }
        
        for _ in 0 ..< 7 {
            let product = MDProduct.init()
            productStorage.saveToStorage(object: product)
        }
        
        for product in products {
            productStorage.removeFromStorage(object: product)
        }
        
        let fetchedProducts = productStorage.getObjectsFromStorage()
        
        XCTAssertEqual(7, fetchedProducts.count)
    }
    
}
