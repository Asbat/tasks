//
//  UIView+Utils.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    func add(subview: UIView) -> UIView {
        addSubview(subview)
        return subview
    }
}
