//
//  AttachPhotosView.swift
//  RetechLabsTest
//
//  Created by Victor on 03/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

class AttachPhotosView: UIView {
    //MARK: IBOUtlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var attachPhotosSwitch: UISwitch!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var model: [UIImage]? {
        didSet {
            photosCollectionView.reloadData()
        }
    }
    
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
    }
}

extension AttachPhotosView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
