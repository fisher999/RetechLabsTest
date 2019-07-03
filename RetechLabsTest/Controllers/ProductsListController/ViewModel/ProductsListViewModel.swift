//
//  ProductsListViewModel.swift
//  RetechLabsTest
//
//  Created by Victor on 02/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import ReactiveSwift

class ProductsListViewModel: BaseViewModel {
    //MARK: Properties
    private let productStorage: ProductStorage
    private var products: [MDProduct] = []
    
    init(productStorage: ProductStorage = ProductStorage.shared) {
        self.productStorage = productStorage
    }
}

//MARK: Helping product methods
extension ProductsListViewModel {
    fileprivate func getAllProducts() {
        self.products = productStorage.getObjectsFromStorage()
    }
    
    fileprivate func productAtIndexPath(indexPath: IndexPath) -> MDProduct? {
        guard indexPath.row < products.count else {return nil}
        
        return products[indexPath.row]
    }
    
    fileprivate func productById(_ id: Int) -> MDProduct? {
        let product = products.filter { (product) -> Bool in
            return product.id == id
        }.first
        
        return product
    }
    
    fileprivate func addProduct(product: MDProduct) {
        self.products.append(product)
    }
    
    fileprivate func removeProductAtIndexPath(_ indexPath: IndexPath) {
        guard indexPath.row < products.count else {return}
        
        self.products.remove(at: indexPath.row)
    }
    
    fileprivate func changeProductAtIndexPath(_ indexPath: IndexPath, by product: MDProduct) {
        guard indexPath.row < products.count else {return}
        removeProductAtIndexPath(indexPath)
        self.products.insert(product, at: indexPath.row)
    }
}

//MARK: TableViewMethods
extension ProductsListViewModel {
    func cellForRowAtIndexPath(_ indexPath: IndexPath) -> MDProduct? {
        return productAtIndexPath(indexPath: indexPath)
    }
}
