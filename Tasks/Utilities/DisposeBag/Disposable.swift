//
//  Disposable.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import Foundation

public protocol Disposable {
    func disposed(by bag: Bag)
    func dispose()
}

extension Disposable {
    public func disposed(by bag: Bag) {
        bag.insert(self)
    }
}
