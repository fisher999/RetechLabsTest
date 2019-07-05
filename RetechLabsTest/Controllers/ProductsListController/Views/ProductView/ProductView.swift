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
    func productView(_ productView: ProductView, didChangeNameIn nameTextField: UITextField)
    func productView(_ productView: ProductView, didFocusOnNameTextField: UITextField)
    func productView(didTappedRemovedButton productView: ProductView)
    func productView(_ productView: ProductView, didTappedRemovePhoto attachPhotoCell: AttachPhotoCell, at indexPath: IndexPath?)
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
    @IBOutlet weak var borderTextFieldView: UIView!
    
    //MARK: Properties
    weak var delegate: ProductViewDelegate?
    
    var model: Model? {
        didSet {
            guard let validModel = model else {return}
            nameTextField.text = validModel.name
            setupBorderTextFieldColor()
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
        removeButton.addTarget(self, action: #selector(didTappedRemoveButton), for: .touchUpInside)
        
        nameTextField.addTarget(self, action: #selector(didChangeName(_:)), for: .editingChanged)
        nameTextField.delegate = self
    }
    
    func setupBorderTextFieldColor() {
        if nameTextField.text?.isEmpty ?? true {
            self.borderTextFieldView.backgroundColor = UIColor.lightGray
        }
        else {
            self.borderTextFieldView.backgroundColor = UIColor.white
        }
    }
}

//MARK: textFieldDelegate
extension ProductView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.productView(self, didFocusOnNameTextField: textField)
        self.borderTextFieldView.backgroundColor = UIColor.lightGray
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        setupBorderTextFieldColor()
    }
}

//MARK: ActiveFrameFieldGetter
extension ProductView: ActiveFrameFieldGetter {
    var activeFieldViewFrame: CGRect? {
        return view.convert(nameTextField.frame, to: self)
    }
}

//MARK: actions
extension ProductView {
    @objc func didChangeName(_ sender: UITextField) {
        delegate?.productView(self, didChangeNameIn: sender)
    }
    
    @objc func didTappedRemoveButton() {
        delegate?.productView(didTappedRemovedButton: self)
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
    func attachPhotosView(didTappedRemovePhoto attachPhotoCell: AttachPhotoCell, at indexPath: IndexPath?) {
        delegate?.productView(self, didTappedRemovePhoto: attachPhotoCell, at: indexPath)
    }
    
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
