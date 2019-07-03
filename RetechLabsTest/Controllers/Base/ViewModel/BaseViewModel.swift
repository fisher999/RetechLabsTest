//
//  BaseViewModel.swift
//  RetechLabsTest
//
//  Created by Victor on 02/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import ReactiveSwift
import UIKit
import Result

class BaseViewModel {
    //MARK: Properties
    var (lifetime, token) = Lifetime.make()
    
}
