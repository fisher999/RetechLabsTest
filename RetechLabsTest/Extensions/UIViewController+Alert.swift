//
//  UIViewController+Alert.swift
//  RetechLabsTest
//
//  Created by Victor on 06/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showActionSheet(title: String?, message: String?, handlers: [(String, UIAlertAction.Style, () -> Void)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for handler in handlers {
            let action = UIAlertAction(title: handler.0, style: handler.1) { (_) in
                handler.2()
            }
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
