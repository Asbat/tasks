//
//  Operation+Disposable.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

extension Operation: Disposable {
    public func dispose() {
        cancel()
    }
}
