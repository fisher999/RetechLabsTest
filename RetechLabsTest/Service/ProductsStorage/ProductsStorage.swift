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
    
    var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
  
        return appDelegate.persistentContainer.viewContext
    }
    
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
    
    func removeAll() {
        self.removeAllRequest()
    }
    
    func replaceProduct(object: MDProduct) {
        self.changeProduct(by: object)
    }
    
    func saveProducts(objects: [MDProduct]) {
        self.saveProducts(products: objects)
    }
}

//Database functions
extension ProductStorage {
    fileprivate func saveProduct(product: MDProduct) {
        fetchProducts()
        
        if fetchedObjects.contains(where: { (fetchedProduct) -> Bool in
            return product == fetchedProduct
        }) {
            changeProduct(by: product)
            return
        }
        
        guard let managedContext = self.managedContext else {return}
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Product",
                                                      in: managedContext) else {return}
        
        guard let savedProduct = NSManagedObject(entity: entity, insertInto: managedContext) as? Product else {return}
        
        
        
        savedProduct.id = Int16(product.id)
        savedProduct.name = product.name
        
        savedProduct.attachPhotos = product.attachPhotos.convert()
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        fetchProducts()
    }
    
    @discardableResult
    fileprivate func fetchProducts() -> [MDProduct] {
        guard let managedContext = self.managedContext else {return []}
        
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
        guard let managedContext = self.managedContext else {return}
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "id==\(product.id)")
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
    
    fileprivate func removeAllRequest() {
        guard let managedContext = self.managedContext else {return}
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
    
        do {
            let result = try managedContext.execute(deleteRequest) as? NSBatchDeleteResult
            let objectIDArray = result?.result as? [NSManagedObjectID]
            let changes: [AnyHashable : Any] = [NSDeletedObjectsKey : objectIDArray as Any]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [managedContext])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func changeProduct(by product: MDProduct) {
        guard let managedContext = managedContext else {return}
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        
        do {
            if let managedObjectProducts = try managedContext.fetch(fetchRequest) as? [Product] {
                if let changeProduct = managedObjectProducts.filter({ (manageObjectProduct) -> Bool in
                    return manageObjectProduct.id == product.id
                }).first {
                    changeProduct.name = product.name
                    changeProduct.count = Int16(product.count)
                    changeProduct.attachPhotos = product.attachPhotos.convert()
                    
                    try managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    fileprivate func saveProducts(products: [MDProduct]) {
        for product in products {
            self.saveProduct(product: product)
        }
    }
}
