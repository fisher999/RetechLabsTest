//
//  AttachPhotoCell.swift
//  RetechLabsTest
//
//  Created by Victor on 03/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

protocol AttachPhotoCellDelegate: class {
    func attachPhotoCell(didTappedCancel cell: AttachPhotoCell)
    func attachPhotoCell(didTappedAddPhoto cell: AttachPhotoCell)
}

class AttachPhotoCell: UICollectionViewCell, NibLoadableView, ReusableView {
    enum CellType {
        case photo(photo:UIImage, isLoaded: Bool)
        case addPhoto
    }
    
    //MARK: IBOutlets
    @IBOutlet fileprivate weak var progressCircleView: OProgressView!
    @IBOutlet fileprivate weak var photoView: UIImageView!
    @IBOutlet fileprivate weak var cellActionButton: UIButton!
    
    //MARK: Properties
    weak var delegate: AttachPhotoCellDelegate?
    
    var progress: Float? {
        didSet {
            guard let validProgress = progress else {return}
            progressCircleView.setProgress(validProgress, animated: true)
            if validProgress == 1.0 {
                progressCircleView.isHidden = true
            }
            else if validProgress < 1.0, progressCircleView.isHidden {
                progressCircleView.isHidden = false
            }
        }
    }
    
    var model: CellType? {
        didSet {
            guard let validModel = model else {return}
            switch validModel {
            case .photo(let image, let isLoaded):
                self.photoView.image = image
                self.progressCircleView.isHidden = isLoaded
                self.cellActionButton.isHidden = isLoaded
                let image = UIImage(named: "cancel")
                self.cellActionButton.setImage(image, for: .normal)
            case .addPhoto:
                self.cellActionButton.isHidden = false
                let image = UIImage(named: "add")
                self.cellActionButton.setImage(image, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        self.cellActionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
}

//MARK: Actions
extension AttachPhotoCell {
    @objc func actionButtonTapped() {
        guard let validModel = model else {return}
        switch validModel {
        case .photo:
            delegate?.attachPhotoCell(didTappedCancel: self)
        case .addPhoto:
            delegate?.attachPhotoCell(didTappedAddPhoto: self)
        }
    }
}
