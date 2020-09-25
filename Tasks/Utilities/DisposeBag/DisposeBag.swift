//
//  DisposeBag.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import Foundation

public protocol Bag {
    func insert(_ disposable: Disposable)
    func dispose()
}

/// Dispose bag usually used for disposing observers.
public class DisposeBag: Bag {
    private var disposables = [Disposable]()
    
    public init() {
        
    }
    
    public func insert(_ disposable: Disposable) {
        disposables.append(disposable)
    }
    
    public func dispose() {
        disposables.forEach({ $0.dispose() })
        disposables.removeAll()
    }
    
    deinit {
        dispose()
    }
}
