//
//  UserDefaults+Autoincrement.swift
//  RetechLabsTest
//
//  Created by Victor on 02/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

extension UserDefaults {
    func autoIncrement() -> Int {
        if let increment = self.object(forKey: "increment") as? Int {
            self.set(increment + 1, forKey: "increment")
            
            return increment
        }
        else {
            self.set(0, forKey: "increment")
            
            return 0
        }
    }
}
