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
    func attachPhotosView(didTappedRemovePhoto attachPhotoCell: AttachPhotoCell, at indexPath: IndexPath?)
    func attachPhotosView(didTappedCancel attachPhotoCell: AttachPhotoCell, at indexPath: IndexPath?)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        attachPhotosSwitch.isOn = false
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.register(AttachPhotoCell.self)
        photosCollectionView.showsHorizontalScrollIndicator = false
        photosCollectionView.showsVerticalScrollIndicator = false
        
        
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
        self.photosCollectionView.isHidden = !self.attachPhotosSwitch.isOn
        if self.attachPhotosSwitch.isOn {
            self.collectionViewHeight.constant = 133
        }
        else {
            self.collectionViewHeight.constant = 0
        }
        
        setNeedsLayout()
        
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
}

//MARK: UICollectionViewDataSource
extension AttachPhotosView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(model?.count)
        return model?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AttachPhotoCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        cell.model = model?[indexPath.row]
        
        return cell
    }
}

extension AttachPhotosView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
}

extension AttachPhotosView: AttachPhotoCellDelegate {
    func attachPhotoCell(didTappedRemovePhoto cell: AttachPhotoCell) {
        let indexPath = self.photosCollectionView.indexPath(for: cell)
        delegate?.attachPhotosView(didTappedRemovePhoto: cell, at: indexPath)
    }
    
    func attachPhotoCell(didTappedCancel cell: AttachPhotoCell) {
        let indexPath = self.photosCollectionView.indexPath(for: cell)
        delegate?.attachPhotosView(didTappedCancel: cell, at: indexPath)
    }
    
    func attachPhotoCell(didTappedAddPhoto cell: AttachPhotoCell) {
        delegate?.attachPhotosView(didTappedAddPhoto: cell)
    }
}
