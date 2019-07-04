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
    
    fileprivate func attachPhotosCellTypesFor(_ indexPath: IndexPath) -> [AttachPhotoCell.CellType] {
        guard let product = productAtIndexPath(indexPath: indexPath) else {return []}
        var cells: [AttachPhotoCell.CellType] = []
        let mapProducts = product.attachPhotos.map { (imageData) -> AttachPhotoCell.CellType in
            return .photo(photo: UIImage(data: imageData), isLoaded: false)
        }
        cells.append(contentsOf: mapProducts)
        cells.append(.addPhoto)
        
        return cells
    }
}

//MARK: TableViewMethods
extension ProductsListViewModel {
    func cellForRowAtIndexPath(_ indexPath: IndexPath) -> ProductView.Model? {
        guard let product = productAtIndexPath(indexPath: indexPath) else {return nil}
        let count = String(product.count)
        let productViewModel = ProductView.Model(name: product.name, count: count, attachPhotos: attachPhotosCellTypesFor(indexPath))
        
        return productViewModel
    }
}

//MARK: events
extension ProductsListViewModel {
    func addButtonDidtapped() {
        let product = MDProduct()
        addProduct(product: product)
    }
}
