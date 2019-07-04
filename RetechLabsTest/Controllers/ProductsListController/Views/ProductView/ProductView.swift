//
//  ProductView.swift
//  RetechLabsTest
//
//  Created by Victor on 03/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

protocol ProductViewDelegate: class {
    func productView(didIncreaseButtonTapped counterView: CounterView)
    func productView(didDeacreaseButtonTapped counterView: CounterView)
    func productView(didTappedCancel attachPhotoCell: AttachPhotoCell, at indexPath: IndexPath?)
    func productView(didTappedAddPhoto attachPhotoCell: AttachPhotoCell)
    func productView(didSwitchAttachPhotos attachView: AttachPhotosView, isAttachPhotos: Bool)
}

class ProductView: UIView {
    struct Model {
        let name: String
        let count: String
        let attachPhotos: [AttachPhotoCell.CellType]
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var attachPhotosView: AttachPhotosView!
    
    //MARK: Properties
    weak var delegate: ProductViewDelegate?
    
    var model: Model? {
        didSet {
            guard let validModel = model else {return}
            nameTextField.text = validModel.name
            counterView.countTitle = validModel.count
            attachPhotosView.model = validModel.attachPhotos
        }
    }
    
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
        counterView.delegate = self
        attachPhotosView.delegate = self
        
        removeButton.setBackgroundImage(UIImage(named: "remove"), for: .normal)
    }
}

//MARK: CounterViewDelegate
extension ProductView: CounterViewDelegate {
    func counterView(didIncreaseButtonTapped counterView: CounterView) {
        delegate?.productView(didIncreaseButtonTapped: counterView)
    }
    
    func counterView(didDeacreaseButtonTapped counterView: CounterView) {
        delegate?.productView(didDeacreaseButtonTapped: counterView)
    }
    
    
}

extension ProductView: AttachPhotosViewDelegate {
    func attachPhotosView(didTappedCancel attachPhotoCell: AttachPhotoCell, at indexPath: IndexPath?) {
        delegate?.productView(didTappedCancel: attachPhotoCell, at: indexPath)
    }
    
    func attachPhotosView(didSwitchAttachPhotos attachPhotoView: AttachPhotosView, isAttachPhotos: Bool) {
        delegate?.productView(didSwitchAttachPhotos: attachPhotoView, isAttachPhotos: isAttachPhotos)
    }
    
    func attachPhotosView(didTappedAddPhoto attachPhotoCell: AttachPhotoCell) {
        delegate?.productView(didTappedAddPhoto: attachPhotoCell)
    }
}
