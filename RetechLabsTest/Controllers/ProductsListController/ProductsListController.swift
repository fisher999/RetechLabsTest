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
        
    }

    func setup() {
        
    }
    
    func bind() {
        
    }
}
