//
//  ProductCell.swift
//  RetechLabsTest
//
//  Created by Victor on 03/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell, ReusableView, NibLoadableView {
    //MARK: IBOutlets
    @IBOutlet weak var productView: ProductView!
    
    var model: ProductView.Model? {
        didSet {
            productView.model = model
        }
    }
    
    var delegate: ProductViewDelegate? {
        return productView.delegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup() {
        productView.layer.shadowColor = UIColor.black.cgColor
        productView.layer.shadowOpacity = 1
        productView.layer.shadowOffset = .zero
        productView.layer.shadowRadius = 10
    }
}
