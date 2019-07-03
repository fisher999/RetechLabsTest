//
//  CounterView.swift
//  RetechLabsTest
//
//  Created by Victor on 03/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

class CounterView: UIView {
    //MARK: IBOUtlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var deacreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet private weak var countLabel: UILabel!
    
    var countTitle: String? {
        didSet {
            countLabel.text = countTitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = loadFromNib()
    }
}
