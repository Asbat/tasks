//
//  Coordinator.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2019 Alexey Stoyanov. All rights reserved.
//

import UIKit

protocol CoordinatorDelegate: class {
    func coordinatorDidRequestDismiss(coordinator: Coordinator)
}

class Coordinator {
    
    // MARK: Properties
    
    weak var delegate: CoordinatorDelegate?
    weak var initialViewController: UIViewController?
    weak var container: UIViewController?
    
    var coordinators = [Coordinator]()
    
    // MARK: Methods
    
    init(container: UIViewController?) {
        self.container = container
    }
    
    /// Override
    func start() -> UIViewController? {
        return nil
    }
    
    /// Reset
    func reset() {
        coordinators.forEach({ $0.reset() })
        coordinators.removeAll()
    }
    
    /// Dismiss
    func dismiss() {
        delegate?.coordinatorDidRequestDismiss(coordinator: self)
    }
}
