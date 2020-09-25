//
//  View.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

protocol BindableView {
    var viewModel: ViewModelProtocol? { get set }
    
    func bindViewModel(viewModel: ViewModelProtocol?)
}

extension BindableView where Self: UIViewController {
    
}
