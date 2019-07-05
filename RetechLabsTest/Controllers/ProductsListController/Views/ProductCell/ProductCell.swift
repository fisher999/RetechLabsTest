//
//  ProductCell.swift
//  RetechLabsTest
//
//  Created by Victor on 03/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

protocol ProductCellDelegate: class {
    func productCell(didIncreaseButtonTapped counterView: CounterView, productCell: ProductCell)
    func productCell(didDeacreaseButtonTapped counterView: CounterView, productCell: ProductCell)
    func productCell(didTappedCancel attachPhotoCell: AttachPhotoCell, productCell: ProductCell, at indexPath: IndexPath?)
    func productCell(didTappedAddPhoto attachPhotoCell: AttachPhotoCell, productCell: ProductCell)
    func productCell(didSwitchAttachPhotos productCell: ProductCell, isAttachPhotos: Bool)
    func productCell(_ productCell: ProductCell, in productView: ProductView, didChangeNameIn nameTextField: UITextField)
    func productCell(_ productCell: ProductCell, didFocusOnNameTextField nameTextField: UITextField, in productView: ProductView)
    func productCell(_ productCell: ProductCell, didTappedRemovedButtonIn productView: ProductView)
    func productCell(_ productCell: ProductCell, productView: ProductView, didTappedRemovePhoto attachPhotoCell: AttachPhotoCell, at indexPath: IndexPath?)
}

class ProductCell: UITableViewCell, ReusableView, NibLoadableView {
    //MARK: IBOutlets
    @IBOutlet weak var productView: ProductView!
    
    var model: ProductView.Model? {
        didSet {
            productView.model = model
        }
    }
    
    weak var delegate: ProductCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        productView.delegate = self
        productView.layer.shadowColor = UIColor.black.cgColor
        productView.layer.shadowOpacity = 1
        productView.layer.shadowOffset = .zero
        productView.layer.shadowRadius = 15
        
        selectionStyle = .none
    }
}

extension ProductCell: ProductViewDelegate {
    func productView(_ productView: ProductView, didTappedRemovePhoto attachPhotoCell: AttachPhotoCell, at indexPath: IndexPath?) {
        delegate?.productCell(self, productView: productView, didTappedRemovePhoto: attachPhotoCell, at: indexPath)
    }
    
    func productView(didTappedRemovedButton productView: ProductView) {
        delegate?.productCell(self, didTappedRemovedButtonIn: productView)
    }
    
    func productView(_ productView: ProductView, didFocusOnNameTextField: UITextField) {
        delegate?.productCell(self, didFocusOnNameTextField: didFocusOnNameTextField, in: productView)
    }
    
    func productView(_ productView: ProductView, didChangeNameIn nameTextField: UITextField) {
        delegate?.productCell(self, in: productView, didChangeNameIn: nameTextField)
    }
    
    func productView(didTappedCancel attachPhotoCell: AttachPhotoCell, at indexPath: IndexPath?) {
        delegate?.productCell(didTappedCancel: attachPhotoCell, productCell: self, at: indexPath)
    }
    
    func productView(didIncreaseButtonTapped counterView: CounterView) {
        delegate?.productCell(didIncreaseButtonTapped: counterView, productCell: self)
    }
    
    func productView(didDeacreaseButtonTapped counterView: CounterView) {
        delegate?.productCell(didDeacreaseButtonTapped: counterView, productCell: self)
    }
    
    func productView(didTappedAddPhoto attachPhotoCell: AttachPhotoCell) {
        delegate?.productCell(didTappedAddPhoto: attachPhotoCell, productCell: self)
    }
    
    func productView(didSwitchAttachPhotos attachView: AttachPhotosView, isAttachPhotos: Bool) {
        delegate?.productCell(didSwitchAttachPhotos: self, isAttachPhotos: isAttachPhotos)
    }
    
    
}
