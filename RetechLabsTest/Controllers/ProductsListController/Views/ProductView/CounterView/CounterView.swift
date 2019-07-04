//
//  CounterView.swift
//  RetechLabsTest
//
//  Created by Victor on 03/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

protocol CounterViewDelegate: class {
    func counterView(didIncreaseButtonTapped counterView: CounterView)
    func counterView(didDeacreaseButtonTapped counterView: CounterView)
}

class CounterView: UIView {
    //MARK: IBOUtlets
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var deacreaseButton: UIButton!
    @IBOutlet private weak var increaseButton: UIButton!
    @IBOutlet private weak var countLabel: UILabel!
    
    //MARK: Properties
    var countTitle: String? {
        didSet {
            countLabel.text = countTitle
        }
    }
    
    weak var delegate: CounterViewDelegate?
    
    //MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = loadFromNib()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = loadFromNib()
        setup()
    }
    
    func setup() {
        increaseButton.addTarget(self, action: #selector(increaseButtonDidTapped), for: .touchUpInside)
        deacreaseButton.addTarget(self, action: #selector(deacreaseButtonDidTapped), for: .touchUpInside)
    }
}

//MARK: Actions
extension CounterView {
    @objc func increaseButtonDidTapped() {
        delegate?.counterView(didIncreaseButtonTapped: self)
    }
    
    @objc func deacreaseButtonDidTapped() {
        delegate?.counterView(didDeacreaseButtonTapped: self)
    }
}
