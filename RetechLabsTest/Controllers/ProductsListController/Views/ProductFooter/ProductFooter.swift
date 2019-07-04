//
//  ProductFooter.swift
//  RetechLabsTest
//
//  Created by Victor on 04/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

protocol ProductFooterDelegate: class {
    func productFooter(addButtonDidTapped productFooter: ProductFooter)
}

class ProductFooter: UIView {
    //MARK: IBOutlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: Properties
    weak var delegate: ProductFooterDelegate?
    
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
        addButton.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
    }
}

//MARK: Actions
extension ProductFooter {
    @objc func addButtonDidTapped() {
        delegate?.productFooter(addButtonDidTapped: self)
    }
}
