//
//  ProductsListViewModel.swift
//  RetechLabsTest
//
//  Created by Victor on 02/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class ProductsListViewModel: BaseViewModel {
    fileprivate enum SumType {
        case increment
        case deacrement
    }
    
    //MARK: Properties
    private let productStorage: ProductStorage
    private var products: [MDProduct] = []
    
    //MARK: Reactive
    var reloadData: Signal<(), NoError>
    fileprivate var reloadDataObserver: Signal<(), NoError>.Observer
    
    var insertRows: Signal<[IndexPath], NoError>
    fileprivate var insertRowsObserver: Signal<[IndexPath], NoError>.Observer
    
    var updateTableHeight: Signal<(), NoError>
    fileprivate var updateTableHeightObserver: Signal<(), NoError>.Observer
    
    var changeModelForCellAtIndexPath: Signal<(ProductView.Model, IndexPath), NoError>
    fileprivate var changeModelForCellAtIndexPathObserver: Signal<(ProductView.Model, IndexPath), NoError>.Observer
    
    init(productStorage: ProductStorage = ProductStorage.shared) {
        self.productStorage = productStorage
        (reloadData, reloadDataObserver) = Signal.pipe()
        (insertRows, insertRowsObserver) = Signal.pipe()
        (updateTableHeight, updateTableHeightObserver) = Signal.pipe()
        (changeModelForCellAtIndexPath, changeModelForCellAtIndexPathObserver) = Signal.pipe()
        
        super.init()
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
    
    fileprivate func addProduct(product: MDProduct) -> [IndexPath] {
        self.products.append(product)
        
        return [IndexPath(row: products.count - 1, section: 0)]
    }
    
    fileprivate func removeProductAtIndexPath(_ indexPath: IndexPath) {
        guard indexPath.row < products.count else {return}
        
        self.products.remove(at: indexPath.row)
    }
    
    fileprivate func changeCountProductAtIndexPath(_ indexPath: IndexPath, by sumType: SumType) {
        guard let product = productAtIndexPath(indexPath: indexPath) else {return}
        removeProductAtIndexPath(indexPath)
        var changedProduct = product
        
        switch sumType {
        case .deacrement:
            if changedProduct.count > 0 {
                changedProduct.count -= 1
            }
        case .increment:
            changedProduct.count += 1
        }
        
        self.products.insert(changedProduct, at: indexPath.row)
    }
    
    fileprivate func changeProductNameAtIndexPath(_ indexPath: IndexPath, by name: String) {
        guard let product = productAtIndexPath(indexPath: indexPath) else {return}
        removeProductAtIndexPath(indexPath)
        var changedProduct = product
        
        changedProduct.name = name
        
        self.products.insert(changedProduct, at: indexPath.row)
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
    
    func numberOfRows() -> Int {
        return self.products.count
        
    }
}

//MARK: events
extension ProductsListViewModel {
    func addButtonDidtapped() {
        let product = MDProduct()
        let indexPaths = addProduct(product: product)
        insertRowsObserver.send(value: indexPaths)
    }
    
    func didSwitchAttachPhoto(_ isOn: Bool, in productCell: ProductCell) {
        updateTableHeightObserver.send(value: ())
    }
    
    func didIncreaseButtonTapped(at indexPath: IndexPath?, counterView: CounterView) {
        guard let index = indexPath else {return}
        changeCountProductAtIndexPath(index, by: .increment)
        if let cellModel = cellForRowAtIndexPath(index) {
            changeModelForCellAtIndexPathObserver.send(value: (cellModel, index))
        }
    }
    
    func didDeacreaseButtonTapped(at indexPath: IndexPath?, counterView: CounterView) {
        guard let index = indexPath else {return}
        changeCountProductAtIndexPath(index, by: .deacrement)
        updateTableHeightObserver.send(value: ())
        if let cellModel = cellForRowAtIndexPath(index) {
            changeModelForCellAtIndexPathObserver.send(value: (cellModel, index))
        }
    }
    
    func didNameChange(at indexPath: IndexPath?, nameTextField: UITextField) {
        guard let index = indexPath else {return}
        guard let name = nameTextField.text else {return}
        changeProductNameAtIndexPath(index, by: name)
    }
}
