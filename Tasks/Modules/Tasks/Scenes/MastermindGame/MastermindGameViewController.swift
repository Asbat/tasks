//
//  MastermindGameViewController.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit
import Combine

class MastermindGameViewController: ViewController {
    
    enum Layout {
        enum Stack {
            static let insets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 0.0, right: 20.0)
            static let spacing: CGFloat = 5.0
            static let size = CGSize(width: 0.0, height: 44.0)
        }
        
        enum Button {
            static let insets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 0.0, right: 20.0)
            static let size = CGSize(width: 90.0, height: 44.0)
        }
    }
    
    // MARK: Properties
    
    weak var mastermindGameViewModel: MastermindGameViewModelProtocol? {
        get {
            return viewModel as? MastermindGameViewModelProtocol
        }
        
        set {
            viewModel = newValue
        }
    }
    
    private let horizontalStack = UIStackView.horizontal(
        views: [UITextField(), UITextField(), UITextField(), UITextField()],
        distribution: .fillEqually,
        alignment: .fill,
        spacing: Layout.Stack.spacing)
    
    private let actionButton = UIButton.with()
    private var actionState: AnyCancellable?
    private var fieldsState: AnyCancellable?
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        // Button
        actionButton.isEnabled = false
        actionButton.addTarget(self, action: #selector(MastermindGameViewController.actionButtonHandler), for: UIControl.Event.touchUpInside)
        
        actionButton.setTitleColor(.black, for: .normal)
        actionButton.setTitleColor(.gray, for: .disabled)
        self.view.add(subview: actionButton)
            .safeAutopin([.top, .right], edgeInsets: Layout.Stack.insets).view
            .autoSize(Layout.Button.size)
        
        // Stack
        (horizontalStack.arrangedSubviews as? [UITextField])?.forEach({
            $0.backgroundColor = .lightGray
            $0.pin(.height, to: horizontalStack, .height)
            $0.textAlignment = .center
            $0.delegate = self
        })
        
        self.view.add(subview: horizontalStack)
            .safeAutopin([.top, .left], edgeInsets: Layout.Stack.insets).view
            .autoHeight(Layout.Stack.size.height).view
            .pin(.right, to: actionButton, .left, constant: Layout.Stack.insets.right)
    }
    
    override func bindViewModel(viewModel: ViewModelProtocol?) {
        super.bindViewModel(viewModel: viewModel)
        
        bindViewData()
    }
}

// MARK: - Private

private extension MastermindGameViewController {
    func bindViewData() {
        self.scene = viewModel?.scene.sink(
            receiveCompletion: { (completion) in
                
            },
            receiveValue: { [weak self] (viewData) in
                guard let self = self else { return }
                guard let viewData = viewData as? MastermindGameViewData else { return }
                
                self.actionButton.setTitle(viewData.actionButtonTitle, for: .normal)
            })
        
        self.actionState = mastermindGameViewModel?.actionStateObject.sink(
            receiveValue: { [weak self] (viewData) in
                guard let self = self else { return }
                
                self.actionButton.isEnabled = viewData.active
            })
        
        self.fieldsState = mastermindGameViewModel?.fieldsStateObject.sink(
            receiveValue: { [weak self] (viewData) in
                guard let self = self else { return }
                
                for (index, fieldState) in viewData.enumerated() {
                    self.horizontalStack.arrangedSubviews[index].backgroundColor = self.color(for: fieldState)
                }
            })
    }
    
    func color(for fieldState: MastermindGameViewData.FieldState) -> UIColor? {
        switch fieldState {
        case .match:
            return .green
            
        case .closeMatch:
            return .orange
            
        case .missing:
            return .red
        }
    }
    
    @objc func actionButtonHandler(sender: UIButton) {
        mastermindGameViewModel?.validate()
    }
}

// MARK: - UITextFieldDelegate

extension MastermindGameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)

            if let index = horizontalStack.arrangedSubviews.firstIndex(of: textField) {
                return mastermindGameViewModel?.shouldUpdate(text: updatedText, at: index) ?? false
            }
        }

        return false
    }
}
