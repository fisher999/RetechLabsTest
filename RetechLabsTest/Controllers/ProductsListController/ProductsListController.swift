//
//  ProductsListController.swift
//  RetechLabsTest
//
//  Created by Victor on 02/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ProductsListController: BaseController {
    //MARK: IBOutlets
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var productsTableView: UITableView!
    
    //MARK: Properties
    let viewModel: ProductsListViewModel
    fileprivate var keyboardHandler = KeyboardNotificationHandler()
    
    lazy fileprivate var didTappedCamera: () -> Void = { [weak self] in
        self?.viewModel.didTappedCameraButton()
    }
    
    lazy fileprivate var didTappedGallery: () -> Void = { [weak self] in
        self?.viewModel.didTappedGalleryButton()
    }
    
    lazy fileprivate var dismiss: () -> Void = { [weak self] in
        self?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Init
    init(viewModel: ProductsListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         keyboardHandler.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardHandler.unsubscribeFromKeyboardNotifications()
    }

    func setup() {
        productsTableView.register(ProductCell.self)
        let productFooter = ProductFooter()
        productFooter.frame = CGRect(x: 0, y: 0, width: productsTableView.frame.width, height: 166)
        
        productsTableView.dataSource = self
        productsTableView.tableFooterView = productFooter
        productsTableView.sectionFooterHeight = 166
        productsTableView.separatorStyle = .none
        productsTableView.rowHeight = UITableView.automaticDimension
        productsTableView.estimatedRowHeight = 300
        
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    
        productFooter.delegate = self
        
        viewModel.preload()
    }
    
    func bind() {
        insertRows <~ viewModel.insertRows
        productsTableView.reactive.reloadData <~ viewModel.reloadData
        updateTableHeight <~ viewModel.updateTableHeight
        changeModelForCell <~ viewModel.changeModelForCellAtIndexPath
        showImagePickerController <~ viewModel.showImagePickerSignal
        removeRows <~ viewModel.removerRows
    }
}

//MARK: Button action
extension ProductsListController {
    @objc func didTapSaveButton() {
        viewModel.saveButtonDidTapped()
    }
}

//MARK: DataSource
extension ProductsListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductCell = tableView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        cell.model = viewModel.cellForRowAtIndexPath(indexPath)
        
        return cell
    }
}

//ProductFooterDelegate
extension ProductsListController: ProductFooterDelegate {
    func productFooter(addButtonDidTapped productFooter: ProductFooter) {
        viewModel.addButtonDidtapped()
    }
}

extension ProductsListController: ProductCellDelegate {
    func productCell(_ productCell: ProductCell, productView: ProductView, didTappedRemovePhoto attachPhotoCell: AttachPhotoCell, at indexPath: IndexPath?) {
        let indexPath = productsTableView.indexPath(for: productCell)
        view
    }
    
    func productCell(_ productCell: ProductCell, didTappedRemovedButtonIn productView: ProductView) {
        let indexPath = productsTableView.indexPath(for: productCell)
        viewModel.removeButtonDidTapped(at: indexPath)
    }
    
    func productCell(_ productCell: ProductCell, didFocusOnNameTextField nameTextField: UITextField, in productView: ProductView) {
        keyboardHandler.setup(withView: view, scrollView: productsTableView, activeFrameGetter: productView)
    }
    
    func productCell(_ productCell: ProductCell, in productView: ProductView, didChangeNameIn nameTextField: UITextField) {
        let indexPath = productsTableView.indexPath(for: productCell)
        viewModel.didNameChange(at: indexPath, nameTextField: nameTextField)
    }
    
    func productCell(didIncreaseButtonTapped counterView: CounterView, productCell: ProductCell) {
        let indexPath = productsTableView.indexPath(for: productCell)
        viewModel.didIncreaseButtonTapped(at: indexPath, counterView: counterView)
    }
    
    func productCell(didDeacreaseButtonTapped counterView: CounterView, productCell: ProductCell) {
        let indexPath = productsTableView.indexPath(for: productCell)
        viewModel.didDeacreaseButtonTapped(at: indexPath, counterView: counterView)
    }
    
    
    func productCell(didTappedCancel attachPhotoCell: AttachPhotoCell, productCell: ProductCell, at indexPath: IndexPath?) {
        //TODO
    }
    
    func productCell(didTappedAddPhoto attachPhotoCell: AttachPhotoCell, productCell: ProductCell) {
    
        let handlers = [("Камера", UIAlertAction.Style.default, didTappedCamera), ("Галерея", UIAlertAction.Style.default, didTappedGallery), ("Отмена", UIAlertAction.Style.destructive, dismiss)]
        self.showActionSheet(title: nil, message: nil, handlers: handlers)
        let indexPath = productsTableView.indexPath(for: productCell)
        viewModel.didTappedAddPhoto(at: indexPath, in: attachPhotoCell)
    }
    
    func productCell(didSwitchAttachPhotos productCell: ProductCell, isAttachPhotos: Bool) {
        viewModel.didSwitchAttachPhoto(isAttachPhotos, in: productCell)
    }
}

//MARK: Binding targets
extension ProductsListController {
    var insertRows: BindingTarget<[IndexPath]> {
        return BindingTarget<[IndexPath]>.init(lifetime: lifetime, action: { [weak self] (indexPaths) in
            DispatchQueue.main.async {
                self?.productsTableView.beginUpdates()
                self?.productsTableView.insertRows(at: indexPaths, with: .bottom)
                self?.productsTableView.endUpdates()
            }
        })
    }
    
    var removeRows: BindingTarget<[IndexPath]> {
        return BindingTarget<[IndexPath]>.init(lifetime: lifetime, action: {[weak self] (indexPaths) in
            DispatchQueue.main.async {
                self?.productsTableView.beginUpdates()
                self?.productsTableView.deleteRows(at: indexPaths, with: .top)
                self?.productsTableView.endUpdates()
            }
        })
    }
    
    var updateTableHeight: BindingTarget<()> {
        return BindingTarget<()>.init(lifetime: lifetime, action: { [weak self] (_) in
            DispatchQueue.main.async {
                self?.productsTableView.beginUpdates()
                self?.productsTableView.endUpdates()
            }
        })
    }
    
    var changeModelForCell: BindingTarget<(ProductView.Model, IndexPath)> {
        return BindingTarget<(ProductView.Model, IndexPath)>.init(lifetime: lifetime, action: { [weak self] (model, indexPath) in
            guard let sself = self else {return}
            guard let cell = sself.productsTableView.cellForRow(at: indexPath) as? ProductCell else {return}
            cell.model = model
        })
    }
    
    var showImagePickerController: BindingTarget<UIImagePickerController> {
        return BindingTarget<UIImagePickerController>.init(lifetime: lifetime, action: {[weak self] (pickerController) in
            guard let sself = self else {return}
            pickerController.delegate = sself
            
            sself.present(pickerController, animated: true, completion: nil)
        })
    }
}

extension ProductsListController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        if let imagePickerDidSelectedImage = viewModel.imagePickerDidSelectedImage {
            imagePickerDidSelectedImage(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
