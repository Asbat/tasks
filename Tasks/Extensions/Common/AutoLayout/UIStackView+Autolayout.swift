//
//  UIStackView+Autolayout.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

extension UIStackView {

    static func with(views: [UIView], distribution: UIStackView.Distribution = .fillProportionally, axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .center, spacing: CGFloat = 0.0) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = axis
        stack.distribution = distribution
        stack.alignment = alignment
        stack.spacing = spacing
        return stack
    }

    static func vertical(views: [UIView], distribution: UIStackView.Distribution = .fillProportionally, alignment: UIStackView.Alignment = .center, spacing: CGFloat = 0.0) -> UIStackView {
        return UIStackView.with(views: views, distribution: distribution, axis: .vertical, spacing: spacing)
    }

    static func horizontal(views: [UIView], distribution: UIStackView.Distribution = .fillProportionally, alignment: UIStackView.Alignment = .center, spacing: CGFloat = 0.0) -> UIStackView {
        return UIStackView.with(views: views, distribution: distribution, axis: .horizontal, spacing: spacing)
    }
}

extension UIView {

    @discardableResult func stackHorizontal(views: [UIView], distribution: UIStackView.Distribution = .fillProportionally, insets: UIEdgeInsets = .zero, spacing: CGFloat = 0.0) -> UIStackView {
        return add(subview: UIStackView.horizontal(views: views, distribution: distribution, spacing: spacing)).autopin(insets: insets).view as! UIStackView
    }

    @discardableResult func stackVertical(views: [UIView], distribution: UIStackView.Distribution = .fillProportionally, insets: UIEdgeInsets = .zero, spacing: CGFloat = 0.0) -> UIStackView {
        return add(subview: UIStackView.vertical(views: views, distribution: distribution, spacing: spacing)).autopin(insets: insets).view as! UIStackView
    }
}
