//
//  Data+Array.swift
//  RetechLabsTest
//
//  Created by Victor on 02/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element == UIImage {
    func convert() -> Data {
        let mutableImageArray = NSMutableArray()
        
        for image in self {
            if let dataImage = image.pngData() {
                mutableImageArray.add(dataImage)
            }
        }
        
        let attachPhotosData = NSKeyedArchiver.archivedData(withRootObject: mutableImageArray)
        
        return attachPhotosData
    }
}
