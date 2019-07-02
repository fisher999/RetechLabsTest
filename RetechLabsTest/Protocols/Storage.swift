//
//  Storage.swift
//  RetechLabsTest
//
//  Created by Victor on 02/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

protocol Storage {
    associatedtype T: UniqueObject
    
    func getObjectsFromStorage() -> [T]
    func saveToStorage(object: T)
    func removeFromStorage(object: T)
    func removeAll()
}
