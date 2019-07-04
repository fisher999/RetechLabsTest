//
//  ProductsListController.swift
//  RetechLabsTest
//
//  Created by Victor on 02/07/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

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
        
    }

    func setup() {
        productsTableView.register(ProductCell.self)
        let productFooter = ProductFooter()
        productsTableView.tableFooterView = productFooter
        addProductFooterConstraints(productFooter: productFooter)
        productFooter.delegate = self
    }
    
    func bind() {
        
    }
    
    func addProductFooterConstraints(productFooter: ProductFooter) {
        let top = NSLayoutConstraint(item: productFooter, attribute: .top, relatedBy: .equal, toItem: productsTableView.tableFooterView, attribute: .top, multiplier: 1.0, constant: 0)
        let leading = NSLayoutConstraint(item: productFooter, attribute: .leading, relatedBy: .equal, toItem: productsTableView.tableFooterView, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailing = NSLayoutConstraint(item: productFooter, attribute: .trailing, relatedBy: .equal, toItem: productsTableView.tableFooterView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: productFooter, attribute: .bottom, relatedBy: .equal, toItem: productsTableView.tableFooterView, attribute: .bottom, multiplier: 1.0, constant: 0)
        productsTableView.tableFooterView?.addConstraints([top, leading, trailing, bottom])
        productsTableView.tableFooterView?.setNeedsLayout()
    }
}

//MARK: DataSource
extension ProductsListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ProductsListController: ProductFooterDelegate {
    func productFooter(addButtonDidTapped productFooter: ProductFooter) {
        viewModel.addButtonDidtapped()
    }
}
