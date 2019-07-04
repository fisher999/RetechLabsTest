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
    
        productFooter.delegate = self
    }
    
    func bind() {
        insertRows <~ viewModel.insertRows
        productsTableView.reactive.reloadData <~ viewModel.reloadData
        updateTableHeight <~ viewModel.updateTableHeight
        changeModelForCell <~ viewModel.changeModelForCellAtIndexPath
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
        //TODO
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
}
