//
//  AttachPhotoCell.swift
//  RetechLabsTest
//
//  Created by Victor on 03/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit
import ReactiveSwift

protocol AttachPhotoCellDelegate: class {
    func attachPhotoCell(didTappedCancel cell: AttachPhotoCell)
    func attachPhotoCell(didTappedAddPhoto cell: AttachPhotoCell)
    func attachPhotoCell(didTappedRemovePhoto cell: AttachPhotoCell)
}

class AttachPhotoCell: UICollectionViewCell, NibLoadableView, ReusableView {
    enum CellType {
        case photo(photo:UIImage?, isLoaded: Bool)
        case addPhoto
    }
    
    //MARK: lifetime
    var (lifetime, token) = Lifetime.make()
    
    //MARK: IBOutlets
    @IBOutlet fileprivate weak var progressCircleView: OProgressView!
    @IBOutlet fileprivate weak var photoView: UIImageView!
    @IBOutlet fileprivate weak var cellActionButton: UIButton!
    @IBOutlet fileprivate weak var removePhotoButton: UIButton!
    
    //MARK: Properties
    weak var delegate: AttachPhotoCellDelegate?
    
    var progress: BindingTarget<Float> {
        return BindingTarget<Float>.init(lifetime: lifetime, action: {[weak self] (progress) in
            guard let sself = self else {return}
            DispatchQueue.main.async {
                sself.progressCircleView.setProgress(progress, animated: true)
                if progress == 1.0 {
                    sself.progressCircleView.isHidden = true
                }
                else if progress < 1.0, sself.progressCircleView.isHidden {
                    sself.progressCircleView.isHidden = false
                }
            }
        })
    }
    
    var model: CellType? {
        didSet {
            guard let validModel = model else {return}
            switch validModel {
            case .photo(let image, let isLoaded):
                self.photoView.image = image?.crop(to: CGSize(width: 90, height: 90))
                self.progressCircleView.isHidden = isLoaded
                self.cellActionButton.isHidden = isLoaded
                let image = UIImage(named: "cancel")
                self.cellActionButton.setImage(image, for: .normal)
                setNeedsLayout()
            case .addPhoto:
                self.cellActionButton.isHidden = false
                self.progressCircleView.isHidden = true
                let image = UIImage(named: "add")
                self.cellActionButton.setImage(image, for: .normal)
                self.cellActionButton.tintColor = UIColor.black
                setNeedsLayout()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        self.cellActionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        self.photoView.layer.cornerRadius = photoView.frame.height / 2
        self.photoView.clipsToBounds = true
        self.removePhotoButton.addTarget(self, action: #selector(removePhotoButtonTapped), for: .touchUpInside)
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
    
    @objc func removePhotoButtonTapped() {
        
    }
}
