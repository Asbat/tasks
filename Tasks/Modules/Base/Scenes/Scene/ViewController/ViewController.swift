//
//  ViewController.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController, BindableView {

    // MARK: Properties
    
    var viewModel: ViewModelProtocol? {
        didSet {
            viewModel?.load()
        }
    }
    
    var scene: AnyCancellable?
    var alert: AnyCancellable?
    
    /// Private
    private var isLoading: Bool = false

    // MARK: Methods

    init(viewModel: ViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        print("Deinit called: \(self)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel(viewModel: viewModel)
        viewModel?.load()
    }
    
    // MARK: Bind view model
    
    func bindViewModel(viewModel: ViewModelProtocol?) {
        self.alert = viewModel?.alert.sink(
            receiveValue: { (viewData) in
                // TODO: show alert
        })
    }
}
