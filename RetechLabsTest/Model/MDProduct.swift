//
//  MDProduct.swift
//  RetechLabsTest
//
//  Created by Victor on 01/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import CoreData

struct MDProduct {
    let id: Int
    var name: String
    var count: Int
    var attachPhotos: [Data]
    
    init(from managedObject: Product) {
        self.id = Int(managedObject.id)
        
        if let name = managedObject.name {
            self.name = name
        }
        else {
            self.name = ""
        }
        
        self.count = Int(managedObject.count)
        
        if let attachPhotosData = managedObject.attachPhotos, let imagesNSArray = NSKeyedUnarchiver.unarchiveObject(with: attachPhotosData) as? NSArray {
            if let photosArray = imagesNSArray as? Array<Data> {
                self.attachPhotos = photosArray
            }
            else {
                self.attachPhotos = []
            }
        }
        else {
            self.attachPhotos = []
        }
        
    }
    
    init() {
        self.id = UserDefaults.standard.autoIncrement()
        self.name = ""
        self.count = 0
        self.attachPhotos = []
    }
}

//MARK: Unique object
extension MDProduct: UniqueObject {
    var objectId: Int {
        return self.id
    }
}

//MARK: Equatable
extension MDProduct: Equatable {
    static func == (lhs: MDProduct, rhs: MDProduct) -> Bool {
        return lhs.objectId == rhs.objectId
    }
}
