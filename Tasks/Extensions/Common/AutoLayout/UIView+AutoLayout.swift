//
//  UIView+Autolayout.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

struct AutoPinResult {
    let view: UIView
    let constraints: [NSLayoutConstraint]?
    var constraint: NSLayoutConstraint? { return constraints?.first }

    init(_ view: UIView, _ constraint: NSLayoutConstraint?) {
        self.view = view
        if let constr = constraint {
            self.constraints = [constr]
        } else {
            self.constraints = []
        }
    }

    init(_ view: UIView, _ constraints: [NSLayoutConstraint?]) {
        self.view = view
        self.constraints = constraints.compactMap {$0}
    }
}

extension AutoPinResult {
    var button: UIButton? {
        return view as? UIButton
    }

    var imageView: UIImageView? {
        return view as? UIImageView
    }

    var stack: UIStackView? {
        return view as? UIStackView
    }

    var textField: UITextField? {
        return view as? UITextField
    }
}

extension UIView {

    @discardableResult
    func autopin(view: UIView? = nil, insets: UIEdgeInsets = .zero) -> AutoPinResult {
        guard insets != .zero else { return autopin(constant: 0, view: view) }

        var constraints = [NSLayoutConstraint?]()

        constraints.append( autopin(.top, constant: insets.top, view: view).constraint )
        constraints.append( autopin(.bottom, constant: insets.bottom, view: view).constraint )
        constraints.append( autopin(.left, constant: insets.left, view: view).constraint )
        constraints.append( autopin(.right, constant: insets.right, view: view).constraint )

        return AutoPinResult(self, constraints.compactMap { $0 })
    }

    @discardableResult
    func autopin(constant: CGFloat = 0, useMargins: Bool = false, view: UIView? = nil) -> AutoPinResult {
        var attrs: [NSLayoutConstraint.Attribute] = [.top, .left, .bottom, .right]
        if useMargins {
            attrs = [.topMargin, .leftMargin, .bottomMargin, .rightMargin]
        }

        var constraints = [NSLayoutConstraint?]()
        attrs.forEach {
            constraints.append( autopin($0, constant: constant, view: view).constraint )
        }

        return AutoPinResult(self, constraints.compactMap { $0 })
    }

    @discardableResult
    func autopin(_ attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0, view: UIView? = nil) -> AutoPinResult {
        guard let superview = view ?? superview else { return AutoPinResult(self, nil) }
        return self.pin(attribute, to: superview, attribute, constant: constant)
    }

    @discardableResult
    func pin(_ attr: NSLayoutConstraint.Attribute, to view: UIView, _ otherAttr: NSLayoutConstraint.Attribute, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relation: NSLayoutConstraint.Relation = .equal) -> AutoPinResult {
        let shouldInvert = attr == .right || attr == .bottom || attr == .rightMargin || attr == .bottomMargin
        let finalConstant = shouldInvert ? -constant : constant
        let constraint = NSLayoutConstraint(item: self, attribute: attr, relatedBy: relation, toItem: view, attribute: otherAttr, multiplier: multiplier, constant: finalConstant)
        self.superview?.addConstraint(constraint)
        return AutoPinResult(self, constraint)
    }

    @discardableResult
    func pinLess(_ attr: NSLayoutConstraint.Attribute, constant: CGFloat) -> UIView {
        let shouldInvert = attr == .right || attr == .bottom || attr == .rightMargin || attr == .bottomMargin
        let finalConstant = shouldInvert ? -constant : constant
        let constraint = NSLayoutConstraint(item: self, attribute: attr, relatedBy: .lessThanOrEqual, toItem: superview, attribute: attr, multiplier: 1, constant: finalConstant)
        self.superview?.addConstraint(constraint)
        return self
    }

    @discardableResult
    func pinMore(_ attr: NSLayoutConstraint.Attribute, constant: CGFloat, toItem: UIView?, itemAttr: NSLayoutConstraint.Attribute) -> UIView {
        let shouldInvert = attr == .right || attr == .bottom || attr == .rightMargin || attr == .bottomMargin
        let finalConstant = shouldInvert ? -constant : constant
        let constraint = NSLayoutConstraint(item: self, attribute: attr, relatedBy: .greaterThanOrEqual, toItem: toItem, attribute: itemAttr, multiplier: 1, constant: finalConstant)
        self.superview?.addConstraint(constraint)
        return self
    }

    @discardableResult
    func autoHeight(_ constant: CGFloat) -> AutoPinResult {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: constant)
        self.addConstraint(constraint)
        return AutoPinResult(self, constraint)
    }

    @discardableResult
    func autoHeight(ratio: CGFloat) -> UIView {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .height,
                                            multiplier: ratio,
                                            constant: 0)
        superview?.addConstraint(constraint)

        return self
    }

    @discardableResult
    func autoSize(_ size: CGSize) -> AutoPinResult {
        let heightConstraint = NSLayoutConstraint(item: self,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: size.height)
        self.addConstraint(heightConstraint)

        let widthConstraint = NSLayoutConstraint(item: self,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: size.width)
        self.addConstraint(widthConstraint)

        return AutoPinResult(self, [heightConstraint, widthConstraint])
    }

    @discardableResult
    func autoWidth(_ constant: CGFloat) -> AutoPinResult {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: constant)
        self.addConstraint(constraint)
        return AutoPinResult(self, constraint)
    }

    @discardableResult
    func autoWidth(ratio: CGFloat) -> AutoPinResult {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .width,
                                            multiplier: ratio,
                                            constant: 0)
        superview?.addConstraint(constraint)
        return AutoPinResult(self, constraint)
    }

    @discardableResult
    func pinToTop(margins: CGFloat = 0) -> AutoPinResult {
        var constraints = [NSLayoutConstraint?]()
        constraints.append( autopin(.top, constant: margins).constraint )
        constraints.append( autopin(.right, constant: margins).constraint )
        constraints.append( autopin(.left, constant: margins).constraint )
        return AutoPinResult(self, constraints.compactMap {$0})
    }

    @discardableResult
    func pinToBottom(margins: CGFloat = 0) -> AutoPinResult {
        var constraints = [NSLayoutConstraint?]()

        constraints.append( autopin(.bottom, constant: margins).constraint )
        constraints.append( autopin(.right, constant: margins).constraint )
        constraints.append( autopin(.left, constant: margins).constraint )
        return AutoPinResult(self, constraints)
    }

    @discardableResult
    func autopin(_ attributes: [NSLayoutConstraint.Attribute], edgeInsets: UIEdgeInsets) -> AutoPinResult {
        var constraints = [NSLayoutConstraint?]()
        attributes.forEach { constraints.append(autopin($0, constant: edgeInsets.insetFor($0)).constraint ) }
        return AutoPinResult(self, constraints)
    }

    @discardableResult
    func equal(_ attribute: NSLayoutConstraint.Attribute, view: UIView, multiplier: CGFloat = 1, priority: UILayoutPriority = UILayoutPriority(1000)) -> UIView {
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: multiplier, constant: 0.0)
        constraint.priority = priority
        superview?.addConstraint(constraint)
        return self
    }
}

// MARK: - Pin to safe area

extension UIView {
    @discardableResult
    func safeAutopin(_ anchors: [UIRectEdge], edgeInsets: UIEdgeInsets, view: UIView? = nil) -> AutoPinResult {
        guard let superview = view ?? superview else { return AutoPinResult(self, nil) }
        
        var constraints = [NSLayoutConstraint]()
        anchors.forEach({ (anchor) in
            switch anchor {
            case .top:
                constraints.append(self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: edgeInsets.top))
                
            case .left:
                constraints.append(self.leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: edgeInsets.left))
                
            case .bottom:
                constraints.append(self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -edgeInsets.bottom))
                
            case .right:
                constraints.append(self.rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor, constant: -edgeInsets.right))

            default:
                break
            }
        })
        
        constraints.forEach({ $0.isActive = true })
        return AutoPinResult(self, constraints)
    }
}

extension UIEdgeInsets {

    func insetFor(_ attribute: NSLayoutConstraint.Attribute) -> CGFloat {
        switch attribute {
        case .right, .rightMargin: return right
        case .left, .leftMargin: return left
        case .bottom, .bottomMargin: return bottom
        case .top, .topMargin: return top
        default: return 0
        }
    }
}

extension NSLayoutConstraint.Attribute {

    var opposite: NSLayoutConstraint.Attribute {
        switch self {
        case .right: return .left
        case .left: return .right
        case .bottom: return .top
        case .top: return .bottom
        case .rightMargin: return .leftMargin
        case .leftMargin: return .rightMargin
        case .topMargin: return .bottomMargin
        case .bottomMargin: return .topMargin
        default: return .notAnAttribute
        }
    }

    var sides: [NSLayoutConstraint.Attribute] {
        switch self {
        case .right, .left: return [.top, .bottom]
        case .bottom, .top: return [.left, .right]
        case .rightMargin, .leftMargin: return [.topMargin, .bottomMargin]
        case .bottomMargin, .topMargin: return [.leftMargin, .rightMargin]
        default: return []
        }
    }

    var axis: NSLayoutConstraint.Axis {
        switch self {
        case .right, .left: return .horizontal
        default: return .vertical
        }
    }
}

extension UIView {
    func getAllConstraints() -> [NSLayoutConstraint] {

        // array will contain self and all superviews
        var views = [self]

        // get all superviews
        var view = self
        while let superview = view.superview {
            views.append(superview)
            view = superview
        }

        // transform views to constraints and filter only those
        // constraints that include the view itself
        return views.flatMap({ $0.constraints }).filter { constraint in
            return constraint.firstItem as? UIView == self ||
                constraint.secondItem as? UIView == self
        }
    }

    func changeWidth(to value: CGFloat) {

        getAllConstraints().filter({
            $0.firstAttribute == .width &&
                $0.relation == .equal &&
                $0.secondAttribute == .notAnAttribute
        }).forEach({$0.constant = value })
    }

    func changeHeight(to value: CGFloat) {

        getAllConstraints().filter({
            $0.firstAttribute == .height &&
                $0.relation == .equal &&
                $0.secondAttribute == .notAnAttribute
        }).forEach({$0.constant = value })
    }
}

protocol UIViewAutolayout {}
extension UIView : UIViewAutolayout {}

extension UIViewAutolayout where Self : UIView {
    static func with(backgroundColor: UIColor = .clear, rounded: CGFloat = 0) -> Self {
        let view = Self()
        view.backgroundColor = backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
