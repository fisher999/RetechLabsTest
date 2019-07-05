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
import UIKit

class ProductsListViewModel: BaseViewModel {
    fileprivate enum SumType {
        case increment
        case deacrement
    }
    
    //MARK: Properties
    private let productStorage: ProductStorage
    private var products: [MDProduct] = []
    
    var imagePickerDidSelectedImage: ((UIImage) -> Void)?
    
    //MARK: Reactive
    var reloadData: Signal<(), NoError>
    fileprivate var reloadDataObserver: Signal<(), NoError>.Observer
    
    var insertRows: Signal<[IndexPath], NoError>
    fileprivate var insertRowsObserver: Signal<[IndexPath], NoError>.Observer
    
    var removerRows: Signal<[IndexPath], NoError>
    fileprivate var removeRowsObserver: Signal<[IndexPath], NoError>.Observer
    
    var updateTableHeight: Signal<(), NoError>
    fileprivate var updateTableHeightObserver: Signal<(), NoError>.Observer
    
    var changeModelForCellAtIndexPath: Signal<(ProductView.Model, IndexPath), NoError>
    fileprivate var changeModelForCellAtIndexPathObserver: Signal<(ProductView.Model, IndexPath), NoError>.Observer
    
    var showImagePickerSignal: Signal<UIImagePickerController, NoError>
    fileprivate var showImagePickerObserver: Signal<UIImagePickerController, NoError>.Observer
    
    fileprivate var downloadingProducers: [SignalProducer<Float, NoError>] = []
    
    init(productStorage: ProductStorage = ProductStorage.shared) {
        self.productStorage = productStorage
        (reloadData, reloadDataObserver) = Signal.pipe()
        (insertRows, insertRowsObserver) = Signal.pipe()
        (updateTableHeight, updateTableHeightObserver) = Signal.pipe()
        (changeModelForCellAtIndexPath, changeModelForCellAtIndexPathObserver) = Signal.pipe()
        (showImagePickerSignal, showImagePickerObserver) = Signal.pipe()
        (removerRows, removeRowsObserver) = Signal.pipe()
        
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
    
    @discardableResult
    fileprivate func removeProductAtIndexPath(_ indexPath: IndexPath) -> [IndexPath] {
        guard indexPath.row < products.count else {return []}
        let product = self.products.remove(at: indexPath.row)
        productStorage.removeFromStorage(object: product)
        
        return [indexPath]
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
        let mapProducts = product.attachPhotos.map { (image) -> AttachPhotoCell.CellType in
            return .photo(photo: image, isLoaded: true)
        }
        cells.append(contentsOf: mapProducts)
        cells.append(.addPhoto)
        
        return cells
    }
    
    fileprivate func save() {
        productStorage.saveProducts(objects: self.products)
    }
    
    fileprivate func addImageAtIndexPath(_ indexPath: IndexPath, image: UIImage) {
        guard let product = productAtIndexPath(indexPath: indexPath) else {return}
        removeProductAtIndexPath(indexPath)
        var changedProduct = product
        changedProduct.attachPhotos.append(image)
        self.products.insert(changedProduct, at: indexPath.row)
    }
    
    fileprivate func downloadingProducer() -> SignalProducer<Float, NoError> {
        var downloadDuration: Int = 0
        let producer = SignalProducer<Float, NoError>.init({ (observer, lifetime) in
            _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                observer.send(value: Float(timer.timeInterval) / 10)
                downloadDuration += 1
                if downloadDuration == 10 {
                    timer.invalidate()
                    
                }
            }
        })
        downloadingProducers.append(producer)
        
        return producer
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

//MARK: Preload
extension ProductsListViewModel {
    func preload() {
        getAllProducts()
    }
}

//MARK: events
extension ProductsListViewModel {
    func addButtonDidtapped() {
        let product = MDProduct()
        let indexPaths = addProduct(product: product)
        insertRowsObserver.send(value: indexPaths)
    }
    
    func removeButtonDidTapped(at indexPath: IndexPath?) {
        guard let index = indexPath else {return}
        let indexPaths = removeProductAtIndexPath(index)
        removeRowsObserver.send(value: indexPaths)
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
        if let cellModel = cellForRowAtIndexPath(index) {
            changeModelForCellAtIndexPathObserver.send(value: (cellModel, index))
        }
    }
    
    func didNameChange(at indexPath: IndexPath?, nameTextField: UITextField) {
        guard let index = indexPath else {return}
        guard let name = nameTextField.text else {return}
        changeProductNameAtIndexPath(index, by: name)
    }
    
    func saveButtonDidTapped() {
        save()
        let products = productStorage.getObjectsFromStorage()
        print(products.count)
    }
    
    func didTappedCameraButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        showImagePickerObserver.send(value: imagePicker)
    }
    
    func didTappedGalleryButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        showImagePickerObserver.send(value: imagePicker)
    }
    
    func didTappedAddPhoto(at indexPath: IndexPath?, in attachCell: AttachPhotoCell) {
        guard let index = indexPath else {return}
        imagePickerDidSelectedImage = { [weak self] image in
            guard let sself = self else {return}
            sself.addImageAtIndexPath(index, image: image)
            if let cellModel = sself.cellForRowAtIndexPath(index) {
                sself.changeModelForCellAtIndexPathObserver.send(value: (cellModel, index))
                sself.downloadingImage(in: attachCell)
            }
        }
    }
    
    func downloadingImage(in attachCell: AttachPhotoCell) {
        let producer = downloadingProducer()
        attachCell.progress <~ producer
        producer.start()
    }
    
    func removePhotoAtIndexPath(atCell cellIndexPath: IndexPath, forPhotoItem itemIndexPath: IndexPath) {
        
    }
}
