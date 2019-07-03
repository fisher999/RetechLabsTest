//
//  Data+Array.swift
//  RetechLabsTest
//
//  Created by Victor on 02/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

extension Array where Element == Data {
    func convert() -> Data {
        let mutableImageArray = NSMutableArray()
        
        for dataImage in self {
            mutableImageArray.add(dataImage)
        }
        
        let attachPhotosData = NSKeyedArchiver.archivedData(withRootObject: mutableImageArray)
        
        return attachPhotosData
    }
}
