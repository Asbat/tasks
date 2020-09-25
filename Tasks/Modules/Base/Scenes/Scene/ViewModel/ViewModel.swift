//
//  ViewModel.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2019 Alexey Stoyanov. All rights reserved.
//

import UIKit
import Combine

protocol ViewModelDelegate: class {
}

protocol ViewModelProtocol: class {
    var scene: PassthroughSubject<ViewData?, Error> { get }
    var alert: PassthroughSubject<AlertViewData, Never> { get }
    
    func load()
}

class ViewModel: ViewModelProtocol {
    
    // MARK: Properties
    
    weak var delegate: ViewModelDelegate?
    
    var scene = PassthroughSubject<ViewData?, Error>()
    var alert = PassthroughSubject<AlertViewData, Never>()
    
    // MARK: Methods
    
    func load() {
        scene.send(prepareViewData())
    }
    
    func prepareViewData() -> ViewData? {
        return nil
    }
}
