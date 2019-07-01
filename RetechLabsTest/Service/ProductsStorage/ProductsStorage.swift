//
//  ProductsStorage.swift
//  RetechLabsTest
//
//  Created by Victor on 01/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ProductStorage: Storage {
    
    typealias T = MDProduct
    
    static var shared: ProductStorage = ProductStorage()
    
    fileprivate var fetchedObjects: [MDProduct] = []
    
    private init() {}
    
    func getObjectsFromStorage() -> [MDProduct] {
        return fetchProducts()
    }
    
    func saveToStorage(object: MDProduct) {
        saveProduct(product: object)
    }
    
    func removeFromStorage(object: MDProduct) {
        removeProduct(product: object)
    }
}

//Database functions
extension ProductStorage {
    fileprivate func saveProduct(product: MDProduct) {
        fetchProducts()
        
        if fetchedObjects.contains(where: { (fetchedProduct) -> Bool in
            return product == fetchedProduct
        }) {
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Product",
                                                      in: managedContext) else {return}
        
        guard let savedProduct = NSManagedObject(entity: entity, insertInto: managedContext) as? Product else {return}
        
        
        
        savedProduct.id = Int16(product.id)
        savedProduct.name = product.name
        
        let mutableImageArray = NSMutableArray()
        
        for dataImage in product.attachPhotos {
            mutableImageArray.add(dataImage)
        }
        
        let attachPhotosData = NSKeyedArchiver.archivedData(withRootObject: mutableImageArray)
        
        savedProduct.attachPhotos = attachPhotosData
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        fetchProducts()
    }
    
    @discardableResult
    fileprivate func fetchProducts() -> [MDProduct] {
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        
        do {
            if let managedObjectProducts = try managedContext.fetch(fetchRequest) as? [Product] {
                self.fetchedObjects = managedObjectProducts.map({ (product) -> MDProduct in
                    return MDProduct(from: product)
                })
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return self.fetchedObjects
    }
    
    fileprivate func removeProduct(product: MDProduct) {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        fetchRequest.predicate = NSPredicate.init(format: "productID==\(product.id)")
        do {
            let objects = try managedContext.fetch(fetchRequest)
            for object in objects {
                managedContext.delete(object)
            }
            try managedContext.save()
        }
        catch let error {
            print("Could not delete. \(error.localizedDescription)")
        }
    }
}
