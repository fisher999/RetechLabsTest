//
//  AttachPhotosView.swift
//  RetechLabsTest
//
//  Created by Victor on 03/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

protocol AttachPhotosViewDelegate: class {
    func attachPhotosView(didTappedCancel attachPhotoCell: AttachPhotoCell)
    func attachPhotosView(didTappedAddPhoto attachPhotoCell: AttachPhotoCell)
    func attachPhotosView(didSwitchAttachPhotos attachPhotoView: AttachPhotosView, isAttachPhotos: Bool)
}

class AttachPhotosView: UIView {
    //MARK: IBOUtlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var attachPhotosSwitch: UISwitch!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    //MARK: Properties
    var model: [AttachPhotoCell.CellType]? {
        didSet {
            photosCollectionView.reloadData()
        }
    }
    
    weak var delegate: AttachPhotosViewDelegate?
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = loadFromNib()
    }
    
    func setup() {
        photosCollectionView.dataSource = self
        photosCollectionView.register(AttachPhotoCell.self)
        attachPhotosSwitch.addTarget(self, action: #selector(didSwitchAttachPhotos(sender:)), for: .valueChanged)
    }
}

//MARK: Actions
extension AttachPhotosView {
    @objc func didSwitchAttachPhotos(sender: UISwitch) {
        delegate?.attachPhotosView(didSwitchAttachPhotos: self, isAttachPhotos: sender.isOn)
        self.invalidateIntrinsicContentSize()
    }
}

//MARK: IntrinsicContentSize
extension AttachPhotosView {
    override var intrinsicContentSize: CGSize {
        self.photosCollectionView.isHidden = self.attachPhotosSwitch.isOn
        if self.attachPhotosSwitch.isOn {
            self.collectionViewHeight.constant = 0
        }
        else {
            self.collectionViewHeight.constant = 133
        }
        
        setNeedsLayout()
        
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
}

//MARK: UICollectionViewDataSource
extension AttachPhotosView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AttachPhotoCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        cell.model = model?[indexPath.row]
        
        return cell
    }
}

extension AttachPhotosView: AttachPhotoCellDelegate {
    func attachPhotoCell(didTappedCancel cell: AttachPhotoCell) {
        delegate?.attachPhotosView(didTappedCancel: cell)
    }
    
    func attachPhotoCell(didTappedAddPhoto cell: AttachPhotoCell) {
        delegate?.attachPhotosView(didTappedAddPhoto: cell)
    }
}
